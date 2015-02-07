Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:37062 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbbBGMmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Feb 2015 07:42:53 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Duncan <1i5t5.duncan@cox.net>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1, SSD+non-SSD (RAID 5/6 question)
Date: Sat, 07 Feb 2015 07:42:50 -0500
MIME-Version: 1.0
Message-ID: <501bdb14-88dc-424e-bd2a-5a6b026e6673@aei.ca>
In-Reply-To: <pan$dd18d$5ac5cdf3$89ab930f$74b0f909@cox.net>
References: <CAPn+qJhxzbG-FjUUG9VzzZvvA=nSyaFxp3PQrMSm10QXrCtNNw@mail.gmail.com>
 <pan$dd18d$5ac5cdf3$89ab930f$74b0f909@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, February 7, 2015 1:39:07 AM EST, Duncan wrote:

> The btrfs raid1 read-mode device choice algorithm

Duncan,

Very interesting suff on the raid1 read select alg.  What changes with 
raid5/6?  Is that alg 'smarter'?

TIA
Ed Tomlinson

