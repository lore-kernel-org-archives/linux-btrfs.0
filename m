Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33197 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbFKLpf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 07:45:35 -0400
Received: by qkca135 with SMTP id a135so320682qkc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 04:45:34 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2015 19:34:13 +0800
Message-ID: <CAGnHSEkEshdECi7TQ73DZRDg=t7kxwB7FCkPOTXruaiwHfzUUQ@mail.gmail.com>
Subject: multiple "devices" with multiple partitions on one SSD
From: Tom Yan <tom.ty89@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all.

So I am thinking of having multiple partitions (50GiB per one) on an
SATA3 SSD (200GiB available) to be used with a single btrfs
filesystem. The reason I am thinking about this is I would like to
start from one partition (or two if necessary), and then add the
remaining one on demand (if they aren't going to be used for other
purpose). So I would like to know whether raid0 has any advantages on
a single drive, or I should just use the "single" profile, or it's a
bad idea either way.

Thanks in advance!
