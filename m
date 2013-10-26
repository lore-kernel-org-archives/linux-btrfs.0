Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:9841 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753815Ab3JZVfY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 17:35:24 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: No space left on device, problem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
Date: Sat, 26 Oct 2013 15:35:17 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <C5E10710-8D46-44D4-AC38-FB66B9938BB1@colorremedies.com>
References: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
To: Igor M <igork20@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 26, 2013, at 1:46 PM, Igor M <igork20@gmail.com> wrote:
> 
> # mount -t btrfs -o compress=lzo,compress-force=lzo /

Why do you have two compression mount options? You need to pick one of these.

> What to do ?

Are there any kernel messages reported by dmesg at the time the copy starts and fails? What's the exact copy command you're using?


Chris Murphy