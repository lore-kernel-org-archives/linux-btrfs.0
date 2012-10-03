Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54740 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab2JCScF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 14:32:05 -0400
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Wed, 3 Oct 2012 14:31:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q93IUCfY28573750
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2012 14:30:12 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q93IU2Xj004713
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2012 14:30:02 -0400
Message-ID: <506C8426.4010008@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 11:29:58 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [e2fsprogs] ext2_dir_entry To ext2_dir_entry_2 Casting
References: <506B31B7.40405@linux.vnet.ibm.com> <506B3A3E.1060003@linux.vnet.ibm.com> <20121002210836.GA15277@thunk.org> <506C786B.4080704@linux.vnet.ibm.com> <20121003175831.GC4237@thunk.org>
In-Reply-To: <20121003175831.GC4237@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 10:58 AM, Theodore Ts'o wrote:

> To clarify, the EXT2_FEATURE_INCOMPAT_FILETYPE flag indicates that
> there _may_ be file type information in the directory entry (and so
> only the low 8 bits of name_len should be considered part of the name
> length), but it does not guarantee that it will be present in the high
> 8 bits of name_len.
>
> If it is not there, then readdir will simply return DT_UNKNOWN in the
> d_type field of the directory entry returned by readdir(2).  This is
> something all application programs have to be prepared to deal with
> --- if they need the file type information, and they get DT_UNKNOWN,
> then they will need to stat the file to get the information.
>
> 	     	     	      	     - Ted
>
In this case, dir_iterate_proc() is being passed into
ext2_dir_iterate2() and is called from ext2fs_process_dir_block(),
not readdir(2). It looks like the main issue would be detecting if the
EXT2_FEATURE_INCOMPAT_FILETYPE flag is -unset- and manually
setting the file type to EXT2_FT_UNKNOWN (there appears to be a case for
handling EXT2_FT_UNKNOWN; so long as the file type is not set to an
undefined value it should be okay).

Thank you for the clarification.

Regards,
Wade

