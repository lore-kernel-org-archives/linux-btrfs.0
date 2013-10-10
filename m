Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3JJD1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 23:27:42 -0400
Message-ID: <5256206C.3080306@oracle.com>
Date: Thu, 10 Oct 2013 11:35:08 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org FILE SYSTEM list:BTRFS"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <525220DC.2030403@oracle.com> <20131008164951.GC12986@twin.jikos.cz> <237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com>
In-Reply-To: <237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  If 'btrfs_file_extent_item' can contain the ref count it would
  solve the current problem quite easily.  (problem is that, its
  of n * n searches to know data extents with its ref for a given
  subvol).

  But what'r the challenge(s) to have ref count in the
  btrfs_file_extent_item ? any thoughts ?

Thanks, Anand
