Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38807 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbDKUrf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Apr 2015 16:47:35 -0400
Received: by wiun10 with SMTP id n10so30283869wiu.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2015 13:47:34 -0700 (PDT)
Received: from [10.0.2.15] (p3E9EE291.dip0.t-ipconnect.de. [62.158.226.145])
        by mx.google.com with ESMTPSA id uo6sm4238752wjc.49.2015.04.11.13.47.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2015 13:47:33 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <55298865.9080401@googlemail.com>
Date: Sat, 11 Apr 2015 22:47:33 +0200
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance {,meta}data to raid5 not working?
References: <20150410221049.GE9470@wloczykij>
In-Reply-To: <20150410221049.GE9470@wloczykij>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A two-drive RAID5? Try 3 drives (btrfs dev add <new-drive> /mountpoint 
first).


On 04/11/2015 12:10 AM, Piotr Szymaniak wrote:
 > I tried today to balance two drive btrfs raid1 to two drive btrfs raid5


-- 
Philip
