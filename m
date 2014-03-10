Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10050 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754361AbaCJT4c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 15:56:32 -0400
Message-ID: <531E18E9.5050206@fb.com>
Date: Mon, 10 Mar 2014 15:56:25 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfstests: add test btrfs/042 for btrfs incremental
 send
References: <1392940976-1790-1-git-send-email-fdmanana@gmail.com> <1393242925-16087-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393242925-16087-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/24/2014 06:55 AM, Filipe David Borba Manana wrote:
> Regression test for a btrfs incremental send issue where invalid
> paths for utimes, chown and chmod operations were sent to the send
> stream, causing btrfs receive to fail.
> 
> If a directory had a move/rename operation delayed, and none of its
> parent directories, except for the immediate one, had delayed
> move/rename operations, after processing the directory's
> references, the incremental send code would issue invalid paths for
> utimes, chown and chmod operations.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
> Btrfs: fix send issuing outdated paths for utimes, chown and chmod
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com> ---
> 

Worked as expected, thanks

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHhjpAAoJEANb+wAKly3Bh9gQANDHrCRfOb0Xwp0EKFreXyL0
6CysWgSsZqUusillUPMNzwu/fY8fKH6ZWU2Q3f1ysx3KH+2cLZqEqdVaG7S5Q6rA
BWpSTwsEDrzshKFOVLCJfVeZdMglgcYkKFyHC+0mym+JG81ksQl9tiSfTo5vXQV4
PuZ5zg9b9FWBCquEnQ7vpyxyVA/h9hc8YDyuKadeN60fYhzxdHIR/3FPqrh+UeCc
XSbMRupNdPCtMVc/mADMfOhiUVQTpsSz+iL3+lVG7lbVp8hAio6DspFETvKyzcUV
S8l7LkknMX1ylFRV/wc5RBVU1MrFih3qn1GOmT/rAMipXM2q5n7CQ4NaVBbYaMRO
AuyPhygQqH1k3FnMBQGIai37StAmhSPlYMDwWSETP3Uw6V0kENWLyPG02U6uM2cI
wBWg86/EUNmt5zC9YTbehuD12Jyb3rv3JyhzNeoNhyJv5o1a7bKvV8Uc1NcVu1ng
fGSO+RWlhqxyoXCwSa5Zor3j3nYUN8pxDk9M/wppTb211oKnYC2xAcGThly4eU7L
rwRrx7f7lG6Ep6R5Y9NAfEqHQftjML3R4Tc+RJ/MgpON4RDEaFX5l2tWOKior/Ss
yAg5vAVejFAbiVs8ueYTN+k5GAiFu7Zsrx/7uohVzMyI2qrxj5ZkxbFYY/fffLZV
LcmEQsMTKiGmV3fXJzyj
=vgY8
-----END PGP SIGNATURE-----
