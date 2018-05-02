Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:41204 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbeEBWvf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 18:51:35 -0400
Received: by mail-oi0-f41.google.com with SMTP id 11-v6so14444759ois.8
        for <linux-btrfs@vger.kernel.org>; Wed, 02 May 2018 15:51:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+EzBbB2HkAbpQhKPhm_h2qE3AqeUFvC0+EYsk=AviyfnzLu5Q@mail.gmail.com>
References: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
 <c552d9cd-5ce9-b55c-747e-3af28ec161b8@suse.com> <CA+EzBbB2HkAbpQhKPhm_h2qE3AqeUFvC0+EYsk=AviyfnzLu5Q@mail.gmail.com>
From: Vijay Chidambaram <vvijay03@gmail.com>
Date: Wed, 2 May 2018 17:50:54 -0500
Message-ID: <CAPaz=EJ4SGD_RGsbxd3mh7rTARCng+FVUtZ8Hw3Y4=s_RfVD+g@mail.gmail.com>
Subject: Re: Strange behavior (possible bugs) in btrfs
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Soujanya Ponnapalli <soujanyap95@gmail.com>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 11:56 AM, Jayashree Mohan
<jayashree2912@gmail.com> wrote:
> Hi Jeff,
>
> On Mon, Apr 30, 2018 at 11:51 AM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 4/30/18 12:04 PM, Vijay Chidambaram wrote:
>>> Hi,
>>>
>>> We found two more cases where the btrfs behavior is a little strange.
>>> In one case, an fsync-ed file goes missing after a crash. In the
>>> other, a renamed file shows up in both directories after a crash.
>>
>> Hi Vijay -
>>
>> What kernel version did you observe these with?  These seem like bugs
>> Filipe has already fixed.
>>
>> -Jeff
>>
>
> These bugs were observed on Kernel 4.16.0-041600-generic.
>

To add on to what Jayashree said, these bugs are still present in the
latest stable release of btrfs. We aren't sure if they have been
patched on a development branch.

We should note that similar bugs have been fixed before in btrfs, but
those patches don't seem to handle these cases.
