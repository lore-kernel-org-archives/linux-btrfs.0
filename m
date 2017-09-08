Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:47818 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbdIHLhU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 07:37:20 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:54860)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1dqHb4-0001T3-Iy
        for linux-btrfs@vger.kernel.org; Fri, 08 Sep 2017 12:37:18 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dqHaz-00062x-R5
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 12:37:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22962.33000.942912.745015@tree.ty.sabi.co.uk>
Date: Fri, 8 Sep 2017 12:37:12 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: test if a subvolume is a snapshot?
In-Reply-To: <20170908085446.GA7876@rus.uni-stuttgart.de>
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> How can I test if a subvolume is a snapshot? [ ... ]

This question is based on the assumption that "snapshot" is a
distinct type of subvolume and not just an operation that
creates a subvolume with reflinked contents.

Unfortunately Btrfs does indeed make snapshots a distinct type
of subvolume... In my 4.4 kernel/progs version of Btrfs it seems
that the 'Parent UUID' is that of the source of the snapshot,
and the source of a snapshot somehow comes with a list to all
the snapshots taken from it:

  #  ls /fs/sda7
  =        @170826  @170829  @170901  @170903  @170905  @170907
  @170825  @170828  @170830  @170902  @170904  @170906  lost+found

  #  btrfs subvolume list /fs/sda7
  ID 431 gen 532441 top level 5 path =
  ID 1619 gen 524915 top level 5 path @170825
  ID 1649 gen 524915 top level 5 path @170826
  ID 1651 gen 524915 top level 5 path @170828
  ID 1652 gen 524915 top level 5 path @170829
  ID 1654 gen 524915 top level 5 path @170830
  ID 1655 gen 523316 top level 5 path @170901
  ID 1656 gen 524034 top level 5 path @170902
  ID 1658 gen 525628 top level 5 path @170903
  ID 1659 gen 527121 top level 5 path @170904
  ID 1660 gen 528719 top level 5 path @170905
  ID 1665 gen 530565 top level 5 path @170906
  ID 1666 gen 532217 top level 5 path @170907

  #  btrfs subvolume show /fs/sda7/= | egrep 'UUID|Parent|Top level|Snap|@'
	  UUID:                   cb99579f-64e5-e94c-b22c-41dcc397c37f
	  Parent UUID:            -
	  Received UUID:          -
	  Parent ID:              5
	  Top level ID:           5
	  Snapshot(s):
				  @170825
				  @170826
				  @170828
				  @170829
				  @170830
				  @170901
				  @170902
				  @170903
				  @170904
				  @170905
				  @170906
				  @170907

  #  btrfs subvolume show /fs/sda7/@170901 | egrep 'UUID|Parent|Top level|Snap|@'
  /fs/sda7/@170901
	  Name:                   @170901
	  UUID:                   851f8ef3-c2af-4b46-89af-0193fd4e6fc4
	  Parent UUID:            cb99579f-64e5-e94c-b22c-41dcc397c37f
	  Received UUID:          -
	  Parent ID:              5
	  Top level ID:           5
	  Snapshot(s):

Note that with typical Btrfs consistency "Parent UUID" is that
the source of the snapshot, while "Parent ID" is that of the
upper level subvolume, and in the "flat" layout for this volume
the snapshot parent is '/fs/sda7/=' and the upper level is
'/fs/sda7' instead.

The different results that you get make me suspect that the
top-level subvolume is "special".
