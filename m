Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62412 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2JQHC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 03:02:26 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so7055273obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 00:02:26 -0700 (PDT)
Message-ID: <507E57F6.6000805@gmail.com>
Date: Wed, 17 Oct 2012 15:02:14 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Questions about mkfs -A option
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm reading the mkfs code, and confused by its -A option.
>From its comments, the value specified by -A should be regarded as
the start of the filesystem. But mkfs will always zero some area
at the beginning of the first dev, regardless -r specified or not.

My question is:
Why mkfs zeros the beginning of the first dev? Is that expected?
And any use case for -A option?


thanks,
