Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35351 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933064AbcIUMM4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 08:12:56 -0400
Received: by mail-it0-f43.google.com with SMTP id r192so125441497ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 05:12:56 -0700 (PDT)
Subject: Re: Status of free-space-tree feature
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com,
        osandov@fb.com
References: <20160921092406.GD16983@twin.jikos.cz>
 <57E2602C.7050703@applied-asynchrony.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <85fb7ee0-7f6a-e8a0-46c6-dac12c3e69d2@gmail.com>
Date: Wed, 21 Sep 2016 08:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <57E2602C.7050703@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-21 06:25, Holger Hoffstätte wrote:
> On 09/21/16 11:24, David Sterba wrote:
>> Hi,
>>
>> as you might have noticed, the [1] wiki Status page lists the
>> free-space-tree as 'Unstable', referencing a problem with the bitmap
>> endianity. This will affect only bigendian systems.
>>
>> There's one more problem that I overlooked but was pointed to by Omar
>> recently.  The initial FST support in btrfs-progs is read-only,
>>
>> https://marc.info/?l=linux-btrfs&m=144113538017042
>>
>> "However, we're not adding the FREE_SPACE_TREE read-only compat bit to
>> the set of supported bits because progs doesn't know how to keep the
>> free space tree consistent."
>>
>> Historically, the initial patchset version did not recognize FST feature
>> and thus refused to write, but then it was pointed by Qu and Holger that
>> the compat_ro bit is missing for FST. I've added it but this was a
>> mistake. This change is going to be reverted.
>
> I'm not sure I understand - can you explain why this is was so wrong?
> Or Omar maybe?
>
> If btrfsck wants to correct something (write), it can simply always
> and unconditionally invalidate the fst instead of trying to "repair"
> it..and I think that's what happens at the moment (at least I think
> it did for me recently). That seems like a safe and simple way.
I know this is what it does with the regular FSC, but I'm not sure if it 
does so with the FST.  If it doesn't, it probably should though.
>
> The fst by itself seems to be working really well even in extreme
> scenarios (Stefan Priebe's 50+ TB filesystems come to mind, which fell
> over on a regular basis before I merged the fst into my "stable++"
> kernels), and considering how many bugs we've seen in the past from
> the v1 cache, I was really hoping that we can make v2 the default
> soon instead of skirting around the issue even longer.
I entirely agree regarding this.  I've not tested it on anywhere near 
that scale, but I've been running it since shortly after support was 
present in both stable kernels and userspace, and I've not seen a single 
issue on any of my systems except for the aforementioned big endian 
issue (which hasn't really affected me that much, since all my big 
endian systems are test VM's anyway).
>
> Of course if there are plain old runtime bugs in the fst then they need
> to be considered, but this seems to be about btrfs-progs support.

