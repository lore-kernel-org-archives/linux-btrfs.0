Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35293 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcBWSKH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 13:10:07 -0500
Received: by mail-qk0-f170.google.com with SMTP id o6so71459544qkc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 10:10:07 -0800 (PST)
Subject: Re: Major HDD performance degradation on btrfs receive
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>, linux-btrfs@vger.kernel.org
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
 <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <4fec7e2f-8464-6a2e-3096-66155f7a58fd@mokrynskyi.com>
 <CAGGqMYQkz0FnU6TFzAqMZf9D3y2-d16xVemoLOW1sC76Eeg-ZA@mail.gmail.com>
 <5ca0c6e3-624e-ebc9-045b-09c5fba9f9a8@mokrynskyi.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56CCA075.8020409@gmail.com>
Date: Tue, 23 Feb 2016 13:09:57 -0500
MIME-Version: 1.0
In-Reply-To: <5ca0c6e3-624e-ebc9-045b-09c5fba9f9a8@mokrynskyi.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-23 12:34, Nazar Mokrynskyi wrote:
> Wow, this is interesting, didn't know it.
>
> I'll probably try noatime instead:)
>
For what it's worth, due to how it's implemented on almost every UNIX 
derived system in existence (including Linux), atimes are essentially 
useless.  A majority of the software that has used them over the years 
has mad the flawed assumption that the atime only gets updated when the 
file data is read or modified, when they actually get updated when ever 
the file data is read or modified, and when the metadata is modified 
(and in some old UNIX systems, the update on file data modification was 
simply implemented as a cascade effect from the mtime getting updated). 
  Mutt is one of the only publicly available programs I know of that 
uses them, and it makes this same flawed assumption.  The only software 
I know of that uses them right is tmpwatch and tmpreaper, which use them 
to clean up /tmp and similar directories when files there haven't been 
touched in a long time, and even those have the option to not use atimes.

Now, long rant aside, you may want to also look into the 'lazytime' 
mount option.  It won't reduce fragmentation, but it should improve 
performance overall, the only downsides are that mtimes might be 
incorrect after a crash, and it's only available in newer kernels (I 
think it got added in 4.0 or 4.1, but I'm not certain).
