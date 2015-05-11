Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32634 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbbEKOSC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 10:18:02 -0400
Message-ID: <5550B9C0.6050902@fb.com>
Date: Mon, 11 May 2015 10:16:32 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: oops BUG unable to handle kernel NULL point dereference IP io_ctl_check_crc
References: <CAJCQCtSK6cejsr=5J=XvWHnU6iUTrQ_gMGV3ExBwoxvO0ZaXcQ@mail.gmail.com> <CAJCQCtSXceHtfNYpOekP+8TfiF7WJeHQNwYyNJRYnD0XT2z-XA@mail.gmail.com>
In-Reply-To: <CAJCQCtSXceHtfNYpOekP+8TfiF7WJeHQNwYyNJRYnD0XT2z-XA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2015 03:43 AM, Chris Murphy wrote:
> On Sat, May 9, 2015 at 12:34 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=97991
> 
> OK it appears to be a 32bit kernel problem, as it happens in an x86_64
> qemu/kvm VM.
> 
> But that same vm with the same version 64bit kernel doesn't exhibit the problem.
> 

Yeah, the GFP mask patch in rc3 will fix it up.  Sorry for the hassle.

-chris

