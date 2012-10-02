Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:59576 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753545Ab2JBPaK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2012 11:30:10 -0400
Message-ID: <506B087F.7030006@gmx.net>
Date: Tue, 02 Oct 2012 17:30:07 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com> <20121002142538.GV14582@twin.jikos.cz> <20121002143232.GE2370@localhost.localdomain> <20121002150543.GW14582@twin.jikos.cz> <20121002152731.GF2370@localhost.localdomain>
In-Reply-To: <20121002152731.GF2370@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02.10.2012 17:27, Josef Bacik wrote:
> On Tue, Oct 02, 2012 at 09:05:43AM -0600, David Sterba wrote:
>> On Tue, Oct 02, 2012 at 10:32:32AM -0400, Josef Bacik wrote:
>>> On Tue, Oct 02, 2012 at 08:25:38AM -0600, David Sterba wrote:
>>>> Hi,
>>>>
>>>> On Mon, Sep 24, 2012 at 04:02:59PM -0400, Josef Bacik wrote:
>>>>> --- a/fs/btrfs/ctree.h
>>>>> +++ b/fs/btrfs/ctree.h
>>>>> @@ -571,6 +571,7 @@ struct btrfs_path {
>>>>>  	unsigned int skip_locking:1;
>>>>>  	unsigned int leave_spinning:1;
>>>>>  	unsigned int search_commit_root:1;
>>>>> +	unsigned int shecantgoanyfarthercapt:1;
>>>>
>>>> so you did not make it to LWN's quote of the week, can you please rename
>>>> it to something sensible?
>>>>
>>>
>>> I don't see what's unsensible about it.
>>
>> Itsfunnybuthardtoreadanddoesnothelpunderstandingthecodewhereitsused.
>>
> 
> Idisagreeithinkithelpstremendouslywiththeunderstandingofthecode,youcantgoanyfarther,butfineineedotaddacommenttobtrfs_next_leafanywaysoi'llnameitsomethingelse,anysuggestions?
> 

wecantgoanyfarther

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

