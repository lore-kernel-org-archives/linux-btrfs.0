Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61935 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbaIQNuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 09:50:12 -0400
Message-ID: <54199160.7090401@fb.com>
Date: Wed, 17 Sep 2014 09:49:20 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <behanw@converseincode.com>, <agk@redhat.com>, <davem@davemloft.net>,
        <dm-devel@redhat.com>, <fabf@skynet.be>, <herbert@gondor.apana.org.au>,
        <jbacik@fb.com>, <snitzer@redhat.com>, <tadeusz.struk@intel.com>
CC: <akpm@linux-foundation.org>, <bruce.w.allan@intel.com>,
        <d.kasatkin@samsung.com>, <james.l.morris@oracle.com>,
        <john.griffin@intel.com>, <linux-btrfs@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-ima-devel@lists.sourceforge.net>,
        <linux-ima-user@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <linux-raid@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <neilb@suse.de>, <qat-linux@intel.com>, <serge@hallyn.com>,
        <thomas.lendacky@amd.com>, <zohar@linux.vnet.ibm.com>,
        <torvalds@linux-foundation.org>,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>
Subject: Re: [PATCH v3 02/12] btrfs: LLVMLinux: Remove VLAIS
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-3-git-send-email-behanw@converseincode.com>
In-Reply-To: <1410766234-1634-3-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/15/2014 03:30 AM, behanw@converseincode.com wrote:
> From: Vinícius Tinti <viniciustinti@gmail.com>
> 
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This is the original VLAIS struct.
> 
> struct {
> 	struct shash_desc shash;
> 	char ctx[crypto_shash_descsize(tfm)];
> } desc;
> 
> This patch instead allocates the appropriate amount of memory using a
> char array using the SHASH_DESC_ON_STACK macro.
> 
> The new code can be compiled with both gcc and clang.
> 
> Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Chris Mason <clm@fb.com>

On the btrfs bits.  Thanks for the v3.

-chris
