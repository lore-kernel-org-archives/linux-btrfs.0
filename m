Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm18-vm6.bullet.mail.sg3.yahoo.com ([106.10.149.101]:37988 "HELO
	nm18-vm6.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758106Ab2IMQOg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 12:14:36 -0400
Message-ID: <1347552515.49957.YahooMailNeo@web190105.mail.sg3.yahoo.com>
Date: Fri, 14 Sep 2012 00:08:35 +0800 (SGT)
From: Sonu <p10sonu@yahoo.com>
Reply-To: Sonu <p10sonu@yahoo.com>
Subject: do_sync_write and do_sync_read
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



--------------

const struct file_operations btrfs_file_operations = {
::

        .read           = do_sync_read,
        .write          = do_sync_write,
----------


trying to locate do_sync_read (write) any idea where are they ?

Thanks

