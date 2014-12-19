Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaLSQtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 11:49:16 -0500
Message-ID: <54945707.50605@redhat.com>
Date: Fri, 19 Dec 2014 10:49:11 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] btrfs-progs: corrupt block, add missing break to
 option I
References: <cover.1419005022.git.dsterba@suse.cz> <42b74f46eeeae9aa4b93e4316d56e7a165a492ae.1419005022.git.dsterba@suse.cz>
In-Reply-To: <42b74f46eeeae9aa4b93e4316d56e7a165a492ae.1419005022.git.dsterba@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/14 10:06 AM, David Sterba wrote:
> Using -I would imply -d.
> 
> Resolves-Coverity-CID: 1258792
> Signed-off-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  btrfs-corrupt-block.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
> index af9ae4d4047c..aeeb1b298f66 100644
> --- a/btrfs-corrupt-block.c
> +++ b/btrfs-corrupt-block.c
> @@ -1096,6 +1096,7 @@ int main(int ac, char **av)
>  				break;
>  			case 'I':
>  				corrupt_item = 1;
> +				break;
>  			case 'd':
>  				delete = 1;
>  				break;
> 

