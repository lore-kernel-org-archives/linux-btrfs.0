Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:41292 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaJPPsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 11:48:31 -0400
Message-ID: <543FE8D4.2040804@giantdisaster.de>
Date: Thu, 16 Oct 2014 17:48:36 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problems running Balance and checking integrity concurrently.
References: <5BE1151D-599F-4FD4-BD6B-AC707C72CEC4@gmail.com>
In-Reply-To: <5BE1151D-599F-4FD4-BD6B-AC707C72CEC4@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 10 Oct 2014 21:35:02 +0800, Wang Shilong wrote:
> Hello，
> 
> I have reproduced a problem with Btrfs integrity and balance using latest
> btrfs kernel,it is very easy to reproduce:
> 
> With mount option “check_int”, and run xfstests/btrfs/ tests, below test could definitely
> reproduce problem:
> 
> ./check tests/btrfs/014

The following two patches fix the issue.


