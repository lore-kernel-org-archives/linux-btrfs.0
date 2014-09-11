Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:46629 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaIKPZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 11:25:45 -0400
Received: from cpe-67-240-76-244.nycap.res.rr.com ([67.240.76.244] helo=[192.168.5.80])
	by mail.mystoragebox.com with esmtpsa (TLS1.0:ECDHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.83)
	(envelope-from <markm-lists@intellasoft.net>)
	id 1XS5dG-0007D1-Dy
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 10:45:58 -0400
Message-ID: <5411B5A6.50103@intellasoft.net>
Date: Thu, 11 Sep 2014 10:45:58 -0400
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs listing is wrong
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Label: 'Root'  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
         Total devices 2 FS bytes used 7.46GiB
         devid    1 size 9.31GiB used 8.06GiB path /dev/sdh6
         devid    3 size 9.31GiB used 8.06GiB path 
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa

# ls -al /dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa
lrwxrwxrwx 1 root root 10 Sep 11 10:43 
/dev/disk/by-uuid/d71404d4-468e-47d5-8f06-3b65fa7776aa -> ../../sdh6

devid 3 should really  be showing /dev/sde6
