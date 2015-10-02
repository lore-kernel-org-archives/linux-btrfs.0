Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:44144 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbbJBGFh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Oct 2015 02:05:37 -0400
Received: from wheezy.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 3ED4DECEE
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2015 16:05:22 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: qgroup problem
Date: Fri, 2 Oct 2015 16:04:36 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201510021604.36442.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sysadm_t:SystemLow-SystemHigh)root@unstable:~/pol# btrfs qgroup show -r -e 
/tmp
qgroupid rfer       excl       max_rfer  max_excl 
-------- ----       ----       --------  -------- 
0/5      1647689728 1647689728 0         0        
0/258    16384      16384      524288000 0        
0/259    16384      16384      536870912 0        
0/261    0          0          0         0        
0/262    0          0          0         0        
(sysadm_t:SystemLow-SystemHigh)root@unstable:~/pol# btrfs subvol list /|grep 
tmp
ID 259 gen 161316 top level 5 path tmp
(sysadm_t:SystemLow-SystemHigh)root@unstable:~/pol# uname -a
Linux unstable 4.2.0-1-amd64 #1 SMP Debian 4.2.1-2 (2015-09-27) x86_64 
GNU/Linux

Above is from a SE Linux test machine running BTRFS with quotas on kernel 
4.2.1.

# scp selinux-policy-default_2.20140421-11.1_all.deb bofh@unstable:/tmp
scp: /tmp/selinux-policy-default_2.20140421-11.1_all.deb: Disk quota exceeded

Above is the result of trying to scp a 2MB file to /tmp.

Is there anything I'm doing wrong or is quotas broken?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
