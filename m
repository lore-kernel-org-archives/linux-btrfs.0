Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:47604 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3HRIDd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Aug 2013 04:03:33 -0400
Message-ID: <5210804C.1090103@gmx.net>
Date: Sun, 18 Aug 2013 10:05:32 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/15] btrfs-progs: fix qgroup realloc inheritance
References: <1376522205-16992-1-git-send-email-zab@redhat.com> <1376522205-16992-11-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-11-git-send-email-zab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/15/13 01:16, Zach Brown wrote:
> qgroup.c:82:23: warning: memcpy with byte count of 0
> qgroup.c:83:23: warning: memcpy with byte count of 0
> 
> The inheritance wasn't copying qgroups[] because a confused sizeof()
> gave 0 byte memcpy()s.  It's been like this for the year since it was
> merged, so I guess this isn't a very important thing to do :).

It only seems to hit if you give -[cx] before -i. I guess only very
few people use these options in the first place. They are primarily
for hosting providers.

Reviewed-by: Arne Jansen <sensille@gmx.net>
> 
> Signed-off-by: Zach Brown <zab@redhat.com>
> ---
>  qgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/qgroup.c b/qgroup.c
> index 038c4dc..86fe2b2 100644
> --- a/qgroup.c
> +++ b/qgroup.c
> @@ -74,7 +74,7 @@ qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
>  
>  	if (*inherit) {
>  		struct btrfs_qgroup_inherit *i = *inherit;
> -		int s = sizeof(out->qgroups);
> +		int s = sizeof(out->qgroups[0]);
>  
>  		out->num_qgroups = i->num_qgroups;
>  		out->num_ref_copies = i->num_ref_copies;
> 

