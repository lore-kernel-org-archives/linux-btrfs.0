Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56607 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab2JWOC2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 10:02:28 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so367728lbo.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 07:02:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508585ED.2010909@gmail.com>
References: <CAGJTRch_o4SDnT+n0WnUfRysj-9T-6GmvsUrSd6XiU6C2JoEsA@mail.gmail.com>
	<20121022160500.GZ25498@carfax.org.uk>
	<508585ED.2010909@gmail.com>
Date: Tue, 23 Oct 2012 09:02:26 -0500
Message-ID: <CAGJTRcgEpL89mpf2a8Hk5wpW4sfLAjoLwuk8d_KyZ=V3=E1iEg@mail.gmail.com>
Subject: Re: RAID 5/6
From: Michael <mike@draftx.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is one of those features that I have been waiting for since I
signed up for the mailing list last year. What source tree is that
code contained in? I would like to start testing it out and helping
out with bug reports(I am only going to use it in a testing VM,
nothing important to work at all). Maybe if I help get it tested and
play around with it I will be familiar when it is really pushed out
and also I can help speed up the development process.
Starting with RAID 1 is an expensive choice for me, I have 8TB of
data(backed up to a friend) that I would have in this array. I was
hoping I could do a RAID 5 of 4 3TB disks and grow it to a RAID 6 of 6
disks in a few months when I need more storage.
Mike

On Mon, Oct 22, 2012 at 12:44 PM, Andreas Philipp
<philipp.andreas@gmail.com> wrote:
>
> On 10/22/2012 06:05 PM, Hugo Mills wrote:
>> On Mon, Oct 22, 2012 at 10:58:07AM -0500, Michael wrote:
>>> Does anyone know when RAID 5/6 are planned to be included in the
>>> Kernel?
>>
>> This is in the FAQ:
>>
>>
> https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_use_RAID.5B56.5D_on_my_Btrfs_filesystem.3F
>>
>> Short answer: Not yet, probably soon.
>>
>>> I am starting to buy parts for my next computer and would very
>>> much like to use BTRFS because I want a FS that can grow and also
>>> recover from undetected read errors - it will be large enough that
>>> these are possible. I'm hoping that it will be available for use in
>>> the coming months.
>>
>> You can switch storage types on the fly, so you could at least
>> start with RAID-1, and then restripe to RAID-5 (or -6) when it's
>> stable enough for you. This assumes that you can manage to use RAID-1
>> in the first place and expand later.
> If you can live without redundancy at the beginning, you could also
> start with RAID-0, and then restripe to RAID-5.
>
> Andreas
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
