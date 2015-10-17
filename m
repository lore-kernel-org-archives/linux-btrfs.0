Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33180 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbJQQgh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Oct 2015 12:36:37 -0400
Received: by wijp11 with SMTP id p11so47098179wij.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2015 09:36:36 -0700 (PDT)
Received: from [10.232.154.184] (host86-187-121-52.range86-187.btcentralplus.com. [86.187.121.52])
        by smtp.googlemail.com with ESMTPSA id jf13sm627498wic.8.2015.10.17.09.36.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Oct 2015 09:36:36 -0700 (PDT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Xavier Gnata <xavier.gnata@gmail.com>
Subject: btrfs autodefrag?
Message-ID: <56227910.7000208@gmail.com>
Date: Sat, 17 Oct 2015 18:36:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On a desktop equipped with an ssd with one 100GB virtual image used 
frequently, what do you recommend?
1) nothing special, it is all fine as long as you have a recent kernel 
(which I do)
2) Disabling copy-on-write for just the VM image directory.
3) autodefrag as a mount option.
4) something else.

I don't think this usecase is well documented therefore I asked this 
question.

Xavier
