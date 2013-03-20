Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3CTRlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 13:41:20 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 31D5EA50F4
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 18:41:19 +0100 (CET)
Date: Wed, 20 Mar 2013 18:41:18 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-03-20
Message-ID: <20130320174118.GC31559@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130318173326.GO7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130318173326.GO7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

finally removing the obsolete utilities, adding the fragmentation visualisation
tool in exchange, setting of io priority for scrub, few more fixes and updates
to the build system.

   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130320

david
---
shortlog:

Anand Jain (1):
      btrfs-progs: defrag return zero on success

Arne Jansen (1):
      Btrfs-progs: tool to visualize fragmentation

David Sterba (2):
      btrfs-progs: convert: access name_len and file_type the old way
      btrfs-progs: makefile: clean static targets

Goffredo Baroncelli (1):
      Removing btrfsctl, btrfs-vol, btrfs-show

Josef Bacik (2):
      Btrfs-progs: fix segfault when using tools fs with tree log
      Btrfs-progs: fix memory leaks on cleanup

Sergei Trofimovich (1):
      Makefile: allow user set LDFLAGS for libbtrfs.so as well

Stefan Behrens (1):
      Btrfs-progs: make scrub IO priority configurable
