Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:28423 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933746Ab3GWVwd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 17:52:33 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:64231 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V1kVS-001z6b-Vo
	for linux-btrfs@vger.kernel.org; Tue, 23 Jul 2013 15:52:31 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Q: Why subvolumes?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
Date: Tue, 23 Jul 2013 15:52:26 -0600
Message-Id: <79612879-8561-4924-B996-570B8594237F@colorremedies.com>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com> <20130723150620.GG20517@carfax.org.uk> <51EEC1BD.9030001@gmail.com> <20130723193013.GI20517@carfax.org.uk> <CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 23, 2013, at 1:43 PM, Jerome Haltom <wasabi@cogito.cx> wrote:

> Why not just create the new dev_id on the destination snapshot of any
> directory?

Right now, snapshots of subvolumes do not contain the contents of contained subvolumes. Hmmm, that sounds horrid.

Subvolume A
	File 1
	File 2
	Subvolume B
		File 3
		File 4

If I snapshot subvolume A, the resulting snapshot does not contain File 3 and File 4. Subvolume B is a regular folder in the snapshot of Subvolume A.

So if every directory were a subvolume by default, this limitation would need to be resolved or snapshotting would become useless. I'm sure there's a more coherent explanation why this isn't desired.

> That way the snapshot can share inodes with is source.


Snapshots already share inode numbers.


Chris Murphy