Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53422 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2IJJXo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 05:23:44 -0400
Received: by obbuo13 with SMTP id uo13so2575540obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 02:23:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com>
References: <504BDCE0.8020407@gmail.com>
	<CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com>
Date: Mon, 10 Sep 2012 12:23:43 +0300
Message-ID: <CAHf9xvadi4vWW7DKiar8pc77HivAyRMDOHinksykHpZNV0j+hQ@mail.gmail.com>
Subject: Re: enquiry about defrag
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: lsching17@gmail.com, jan.steffens@gmail.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

You need to compile the latest version of filefrag, it has some fixes
by Liu Bo wrt to that. However, even then, filefrag may not report the
correct the extent count for btrfs. According to filefrag_fiemap(), it
tries to check whether physical extents are consecutive on disk and
then considers them as a single extent. For btrfs this may not always
be true, because logically the extents might not be consecutive, even
though they are consecutive on disk. xfstest 281 fails for me because
of this. (filefrag -v, however, seems to show BTRFS extents
correctly).
For me the best way is to check the output of btrfs-debug-tree.

Alex.




On Sun, Sep 9, 2012 at 3:30 AM, Jan Steffens <jan.steffens@gmail.com> wrote:
> On Sun, Sep 9, 2012 at 2:03 AM, ching <lsching17@gmail.com> wrote:
>> 2. Is there any command for the fragmentation status of a file/dir ? e.g. fragment size, number of fragments.
>
> Use the "filefrag" command, part of e2fsprogs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
