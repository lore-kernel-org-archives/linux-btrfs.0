Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42088 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JCM51 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 08:57:27 -0400
Received: by oagh16 with SMTP id h16so7332541oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 05:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506B087F.7030006@gmx.net>
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
	<20121002142538.GV14582@twin.jikos.cz>
	<20121002143232.GE2370@localhost.localdomain>
	<20121002150543.GW14582@twin.jikos.cz>
	<20121002152731.GF2370@localhost.localdomain>
	<506B087F.7030006@gmx.net>
Date: Wed, 3 Oct 2012 14:57:26 +0200
Message-ID: <CAHf9xvbKMLjrn2MOo4O+NZhHHOFUaXsJ+KwkqBkbUvKKbD9jYg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
in send code, in full_send_tree() there is code like this:
                key.objectid = found_key.objectid;
                key.type = found_key.type;
                key.offset = found_key.offset + 1;

                ret = btrfs_next_item(send_root, path);
                if (ret < 0)
                        goto out;
                if (ret) {
                        ret  = 0;
                        break;

It wants to jump to the next greater key in the tree, whatever
objectid it has (the reason is that here we need to traverse the whole
file tree). I believe with your change it might get broken... What do
you think?

Thanks,
Alex.




On Tue, Oct 2, 2012 at 5:30 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 02.10.2012 17:27, Josef Bacik wrote:
>> On Tue, Oct 02, 2012 at 09:05:43AM -0600, David Sterba wrote:
>>> On Tue, Oct 02, 2012 at 10:32:32AM -0400, Josef Bacik wrote:
>>>> On Tue, Oct 02, 2012 at 08:25:38AM -0600, David Sterba wrote:
>>>>> Hi,
>>>>>
>>>>> On Mon, Sep 24, 2012 at 04:02:59PM -0400, Josef Bacik wrote:
>>>>>> --- a/fs/btrfs/ctree.h
>>>>>> +++ b/fs/btrfs/ctree.h
>>>>>> @@ -571,6 +571,7 @@ struct btrfs_path {
>>>>>>   unsigned int skip_locking:1;
>>>>>>   unsigned int leave_spinning:1;
>>>>>>   unsigned int search_commit_root:1;
>>>>>> + unsigned int shecantgoanyfarthercapt:1;
>>>>>
>>>>> so you did not make it to LWN's quote of the week, can you please rename
>>>>> it to something sensible?
>>>>>
>>>>
>>>> I don't see what's unsensible about it.
>>>
>>> Itsfunnybuthardtoreadanddoesnothelpunderstandingthecodewhereitsused.
>>>
>>
>> Idisagreeithinkithelpstremendouslywiththeunderstandingofthecode,youcantgoanyfarther,butfineineedotaddacommenttobtrfs_next_leafanywaysoi'llnameitsomethingelse,anysuggestions?
>>
>
> wecantgoanyfarther
>
>> Josef
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
