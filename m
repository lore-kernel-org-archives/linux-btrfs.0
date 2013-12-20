Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22163 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030224Ab3LTOEu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 09:04:50 -0500
Message-ID: <52B44E74.60100@fb.com>
Date: Fri, 20 Dec 2013 09:04:36 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Frank Holton <fholton@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5] Btrfs: convert printk to btrfs_ and fix BTRFS prefix
References: <1386878261-2348-1-git-send-email-fholton@gmail.com> <1387474005-15373-1-git-send-email-fholton@gmail.com>
In-Reply-To: <1387474005-15373-1-git-send-email-fholton@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Still failing to build

fs/btrfs/tests/extent-io-tests.c: In function ‘process_page_range’:
fs/btrfs/tests/extent-io-tests.c:59:4: error: implicit declaration of 
function ‘btrfs_err’ [-Werror=implicit-function-declaration]
btrfs_err(BTRFS_I(inode)->root->fs_info,
^
fs/btrfs/tests/extent-io-tests.c:59:4: error: implicit declaration of 
function ‘BTRFS_I’ [-Werror=implicit-function-declaration]
fs/btrfs/tests/extent-io-tests.c:59:28: error: invalid type argument of 
‘->’ (have ‘int’)
btrfs_err(BTRFS_I(inode)->root->fs_info,
^
Make sure you have the sanity tests config option enabled so you can 
make sure everything is getting built. Thanks,

Josef
