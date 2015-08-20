Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:58147 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751016AbbHTL30 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 07:29:26 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 2/2] btrfs-progs: device delete to accept devid
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <55D5BA12.20007@inwind.it>
Date: Thu, 20 Aug 2015 13:29:22 +0200
MIME-Version: 1.0
In-Reply-To: <1439548611-29730-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>
 <1439548611-29730-3-git-send-email-anand.jain@oracle.com>

Hi Anand
On 2015-08-14 12:36, Anand Jain wrote:
> This patch introduces new option <devid> for the command
> 
[...]

> +
> +		if (is_numerical(argv[i])) {
> +			argv3.devid = arg_strtou64(argv[i]);
> +			its_num = true;
> +		} else if (is_block_device(argv[i])) {


please be aware that is_block_device(), returns 
- 1 if the file is a block device, 
- < 0 in case of an error (eg: file not found)
- 0 otherwise

so I suggest to change the check in

 +		} else if (is_block_device(argv[i]) == 1) {

[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
