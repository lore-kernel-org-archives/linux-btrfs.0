Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:58401 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753316AbaIPULN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 16:11:13 -0400
Received: from [192.168.0.10] (lns-bzn-50f-81-56-234-61.adsl.proxad.net [81.56.234.61])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id s8GKGnSe009082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 22:16:50 +0200 (CEST)
Message-ID: <5418995C.2000708@bordeaux.inra.fr>
Date: Tue, 16 Sep 2014 22:11:08 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Problem with a filesystem
References: <54185D48.5060701@bordeaux.inra.fr> <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com>
In-Reply-To: <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2014 07:17 PM, Chris Murphy wrote:
> 
> Debian 7.5 is based on kernel 3.2 which is very old in Btrfs terms. What kernel version are you using, and version of btrfs-progs?
> 
> Chris Murphy
You're right,
In the beginning, I used the btrfs-progs provided by my debian (kernel
3.2.0-4 and btrfs version 0.19) but later, I compiled and used the git
one (3.16).
More information, 'btrfs filesystem show' gives :

Label: none  uuid: 9ddd403a-2863-4e71-b28d-d2931a133af3
	Total devices 1 FS bytes used 18.67TiB
	devid    1 size 25.34TiB used 22.47TiB path /dev/sda4

Btrfs v3.16

