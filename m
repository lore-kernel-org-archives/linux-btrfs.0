Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49244 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751817AbaIPV1I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:27:08 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:52769 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XU0HE-00009S-C0
	for linux-btrfs@vger.kernel.org; Tue, 16 Sep 2014 15:27:08 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with a filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5418995C.2000708@bordeaux.inra.fr>
Date: Tue, 16 Sep 2014 15:27:07 -0600
Message-Id: <82857E4F-9FF6-4110-993F-35830A44BC04@colorremedies.com>
References: <54185D48.5060701@bordeaux.inra.fr> <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com> <5418995C.2000708@bordeaux.inra.fr>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 16, 2014, at 2:11 PM, Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr> wrote:

> On 09/16/2014 07:17 PM, Chris Murphy wrote:
>> 
>> Debian 7.5 is based on kernel 3.2 which is very old in Btrfs terms. What kernel version are you using, and version of btrfs-progs?
>> 
>> Chris Murphy
> You're right,
> In the beginning, I used the btrfs-progs provided by my debian (kernel
> 3.2.0-4 and btrfs version 0.19) but later, I compiled and used the git
> one (3.16).
> More information, 'btrfs filesystem show' gives :
> 
> Label: none  uuid: 9ddd403a-2863-4e71-b28d-d2931a133af3
> 	Total devices 1 FS bytes used 18.67TiB
> 	devid    1 size 25.34TiB used 22.47TiB path /dev/sda4


Try to mount normally, then with -o recovery, then with -o ro,recovery. Include dmesg showing any messages that appear for these attempts.

Chris Murphy