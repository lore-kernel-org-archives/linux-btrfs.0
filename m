Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8330 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417AbaCGSWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 13:22:25 -0500
Message-ID: <531A0E5B.108@fb.com>
Date: Fri, 7 Mar 2014 13:22:19 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfstests: add test for btrfs send issuing premature
 rmdir operations
References: <1392820352-8550-1-git-send-email-fdmanana@gmail.com> <1393242878-16039-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393242878-16039-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/24/2014 06:54 AM, Filipe David Borba Manana wrote:
> Regression test for btrfs incremental send issue where a rmdir
> instruction is sent against an orphan directory inode which is not
> empty yet, causing btrfs receive to fail when it attempts to remove
> the directory.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
> Btrfs: fix send attempting to rmdir non-empty directories
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com> ---

Looks good to me,

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGg5bAAoJEANb+wAKly3BFtMQAMDITxFeFKRw5o5g88NUJT+n
/AQp584QUb+sBhJnyYVET98S47R4C9d7jAu8fUxUJd2FaZ0UPR+rl/LnpdYXy8oJ
29A2tvbSiOZGQp+kWlGpLqKmmEj/3R/0QZwTrB1jsxKwVsH+OGK1fazOwhkahloL
8R6xBtcvMzkBFEQ08T0dmodDaWKPp8dgztcScrVt+RGkePPVoKE9X4hwTwAl8muk
nPv9TvRULOs2emvxuTnEVqZfou0HcOTuKWXAOXN2peXBe324SjfQ0JmAMjtG1Ukw
nAs5wu8eII1k9/rjGLarNhpuSuMaM5tth0tIb2ebYwxwpYpY6o4eNN2RR6vWlCEz
vULou68VKdOG6/c6uO6cXuI8zOwScWuYyYFXFLTFpAhjdKwY1HaCwSanvnamdYy8
kNITDGkYSqs0Abj9wzQDcJcTrjpHDDe/3olb5LMJjrdTneMyDVXc+Ym+FbBhmQUX
d7vC+a7sRVWwN4xGoqxDgZZQLpGBEO60FhA5kIO9lgis2LdG8SXE0ch4sQuWZ8iC
S9Aw46dssmiY+d3BkugCOPW/7IlID/obLGUF+CWcWMkxSMbwaPn6RfNJmW+9k+rv
fkUVj+U75pBtnuwW3LxV7gUq8HwTz8G1fh+96o41yKXpayBQUoIA47AHCUZtP9Fi
RemqwFmZxhi7ztZYfni2
=8Kl8
-----END PGP SIGNATURE-----
