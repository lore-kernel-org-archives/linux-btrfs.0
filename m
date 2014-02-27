Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37009 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbaB0P40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 10:56:26 -0500
Message-ID: <530F6025.1030208@fb.com>
Date: Thu, 27 Feb 2014 10:56:21 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: =?UTF-8?B?6ZKx5Yev?= <alanqk@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
References: <1390500472-15144-1-git-send-email-jbacik@fb.com> <CAOfOLh-AoQ=+Zvk2LRx4frFD6005gXweY+EMVnZyen5jwGGv9Q@mail.gmail.com>
In-Reply-To: <CAOfOLh-AoQ=+Zvk2LRx4frFD6005gXweY+EMVnZyen5jwGGv9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/27/2014 10:38 AM, 钱凯 wrote:
> I'm a little confused of what "avg_delayed_ref_runtime" means.
> 
> In __btrfs_run_delayed_refs(), "avg_delayed_ref_runtime" is set to
> the runtime of all delayed refs processed in current transaction
> commit. However, in btrfs_should_throttle_delayed_refs(), we based
> on the following condition to decide whether throttle refs or not: 
> ***************************************** avg_runtime =
> fs_info->avg_delayed_ref_runtime; if (num_entries * avg_runtime >=
> NSEC_PER_SEC) return 1; ***************************************** 
> It looks like "avg_delayed_ref_runtime" is used as runtime of each 
> delayed ref processed in average here. So what does it really
> means?
> 

Yeah I screwed this up, I should have been dividing the total time by
the number of delayed refs I ran.  I have a patch locally to fix it
and I'll send it out after I finish my qgroup work.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTD2AlAAoJEANb+wAKly3BQkEP/0F/LGGDsO+x63SAFh/apRZo
ZVmzi1yJGiArFImFs8IwZHKgr/HpP9yYYFqyDCTSYrErI32bjpPbSDKlFDiIKYBq
6mTptPlC6AJQcMJf3oV2SqUoQxI6Ea+04QaTtZwE5pDaTZsjD47QYfSyw/i+YwOr
Ds11ayDeU3FSj8JVYDKFg5ZBifv/mIHbh1fb8xc4R5XCWsbRzIL9LiQa9c56EEOq
vzXp57TIetbJdliK0cYQtPkA7R40us8TqVBH5MfcZPgITyBun3e0zrGxWmW6caTs
viejEbqDhyHLHCing+mMI6GX7w16duq5oG+w4nnjjyuMzWAyNN2pxloqQsWwOyv8
7+33JZCtVG/txRMIXkvc3bqzetrUyPAruo+M3pstN7B2dph6TDV0QJSFnxee6mKf
4/zseNOJtQqjHe5QJNcVJtkDaxgGBkSONHLm5Gz8rFU3XKcNZQcocV+0EtIjE7Zs
D5oDYCAyrxG1VKoFWhdaS883PDokRr75jcnFui4GhhFr5OAOdS3OOTLKVizWUag1
O11d9XsjnzLWiVTsZH+f4K0ONQcUwJFV0zADgYsXtU2LDHHNIPZX9+qSAa+L66hT
Ki6hocoZ4cXyGWcTZPtlGHxAmV2kEh8/Tr1ePfwy7FzTrg9hWUGLXY0DliQDPmIB
w3TdOa+Ghjl8dcaGc2rX
=kSsY
-----END PGP SIGNATURE-----
