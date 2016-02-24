Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbcBXMmT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 07:42:19 -0500
Date: Wed, 24 Feb 2016 13:42:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] fstests: btrfs/011 use replace_options
Message-ID: <20160224124208.GD23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455888329-16981-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 19, 2016 at 09:25:28PM +0800, Anand Jain wrote:
> This patch fixes test btrfs/011 which intended to use -r option
> but was never used since its associated args 'replace_options'
> didn't make it to the cli.

After this patch the tests fails due to extra output. I've tested
several kernels (4.5 rcs), HDD and SSD so it's not caused by my testing
setup.

--- tests/btrfs/011.out 2013-08-29 11:58:37.000000000 +0200
+++ /root/xfstests/results//btrfs/011.out.bad   2016-02-24 12:44:45.562234906 +0100
@@ -1,3 +1,68 @@
 QA output created by 011
 *** test btrfs replace
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+warning devid 2 not found already
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+warning devid 2 not found already
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+warning devid 2 not found already
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
+bytenr mismatch, want=20987904, have=0
+Couldn't read chunk root
 *** done
