Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:25878 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751350Ab3JZWRh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 18:17:37 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: No space left on device, problem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAEezp7uaoZow7vjArHq4E+aD9nxTwEFwvd5VrjUUuNcn4-B1cQ@mail.gmail.com>
Date: Sat, 26 Oct 2013 16:17:33 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <9E910E84-766B-44BB-9EA5-D848016A79D6@colorremedies.com>
References: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com> <C5E10710-8D46-44D4-AC38-FB66B9938BB1@colorremedies.com> <CAEezp7uaoZow7vjArHq4E+aD9nxTwEFwvd5VrjUUuNcn4-B1cQ@mail.gmail.com>
To: Igor M <igork20@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 26, 2013, at 3:53 PM, Igor M <igork20@gmail.com> wrote:

> 
> I even added enospc_debug mount option, still no messages.

If it were kernel enospc, you should have messages in dmesg. 

What version of btrfs progs when making the btrfs volume?

> 
> cp: failed to extend ‘/usr/local/mysql/data/gbdata/parts_0016.MYD’: No
> space left on device

Reboot with kernel parameter ignore_loglevel and retry the copy, and see if you now have anything in dmesg at the time of the copy.


> 
> It's the same error if I try to copy for ex. with midnight commander.

I have the same kernel version, the same mount options, and use the same cp -a on a 5.3GB file and cannot reproduce your results.


Chris Murphy