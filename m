Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13113 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbaCGQAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 11:00:24 -0500
Message-ID: <5319ED0A.4040500@fb.com>
Date: Fri, 7 Mar 2014 11:00:10 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Btrfs: don't skip the page flush since the enospc
 is not brought by it
References: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/27/2014 12:58 AM, Miao Xie wrote:
> As we know, btrfs flushes the continuous pages as many as
> possible, but if all the free spaces are small, we will allocate
> the spaces by several times, and if there is something wrong with
> the space reservation, it is very likely that some allocations
> succeed and the others fail. But the current code doesn't take this
> case into account, and set the error flag for the pages though
> their spaces are allocated successfully. It introduces a problem
> that we can not umount the fs after the above problem happens
> because we need wait for the flush of those pages whose spaces are
> allocated. This patch fixes the above problem, and makes the btrfs
> developers happy when they investigate the problem of the space
> reservation.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com> --- 
> fs/btrfs/extent_io.c | 15 +++++++++++++-- 1 file changed, 13
> insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c index
> fbe501d..97595ea 100644 --- a/fs/btrfs/extent_io.c +++
> b/fs/btrfs/extent_io.c @@ -3198,8 +3198,19 @@ static int
> __extent_writepage(struct page *page, struct writeback_control
> *wbc, &nr_written); /* File system has been set read-only */ if
> (ret) { -				SetPageError(page); -				goto done; +				/* +				 *
> Private2 means we allocate the space +				 * for this page
> successfully, and enospc +				 * error doesn't set the fs to be
> R/O, so +				 * we can write out the page and needn't +				 * set
> error flag for this page. If so, we +				 * can prevent the umount
> task from being +				 * blocked. +				 */ +				if (!(ret == -ENOSPC
> && PagePrivate2(page))) { +					SetPageError(page); +					goto
> done; +				}

So now we just ignore ret == -ENOSPC, we still need to return this
back to the caller.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGez/AAoJEANb+wAKly3B9z4QAJ7VWrt7yfW+IpjzVGViPrmb
S/Q+nuUEZjFk9huKePz33MaT76gWZlrFM6ZgfSLIEP3gPDaQIz+mrCmDBDSnD0uT
ZJypte70l74Rfmp0gBHs+kv9VQPQkeDE17PMGCJBHnqvm/P45PgYU81nWAMhh3uQ
Khsu5TDW7Tddi8FHyuD9a8TBdMlZfRLDOvWCTY/9OUPpRhaOhL8RBffw6iKfnq/t
M32nGEbZGH1y/kWWc39JNKlUwzW0m0oclznPKp0wXo+lMFmHwl76TGgBl0tvLyAs
VGhv101dH0b7vuQOerXSajVjBGFUqovIW3lDPwf4aU4XWSSebbXxeaYiEs5YMFU4
ivzXEMpYBHEteSW9TzJ0Th+D60LhG2vApsG10Ewj7xEblCjcaO8mej6L0j7citw0
WtNiSACyvIlw4zCWT3699UJlmIJ2fsrxEb5SKfE5QFpOXshhSciA8YZJyuX2EBVE
je/rUMhTLCqkuY4zKZLzJiqRhNGQQbWZn4+SmRxpg5RsuxzIZzZcWiEEfucdhB6w
7fKhtMBcY4rUzszG2otEbQaPLNvUa/u04448/gsYhvwy9II0WSkLbe3LF0IS1Z6o
DM0vUE3FAI80EL/fwyg2VvyxOOSYSE9feoX5ClJOZ5qJamdSqLI9PND04lMz6Dp0
+UUKtPx2wn6CnqO3vBeH
=94MT
-----END PGP SIGNATURE-----
