Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58219 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab3KZPRL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 10:17:11 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so7204275wib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 07:17:10 -0800 (PST)
Received: from [192.168.0.29] (ppp-2-85-89-247.home.otenet.gr. [2.85.89.247])
        by mx.google.com with ESMTPSA id qc10sm61603590wic.9.2013.11.26.07.17.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 26 Nov 2013 07:17:05 -0800 (PST)
Message-ID: <5294BB46.2040602@gmail.com>
Date: Tue, 26 Nov 2013 17:16:22 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Dedup on read-only snapshots
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

According to https://github.com/g2p/bedup/tree/wip/dedup-syscall
"The clone call is considered a write operation and won't work on 
read-only snapshots."
Is this fixed on newer kernels?

