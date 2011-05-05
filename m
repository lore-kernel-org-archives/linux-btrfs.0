From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 05 May 2011 21:19:43 +0200
Message-ID: <4DC2F84F.8030107@gmail.com>
References: <1304531920-2890-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1304531920-2890-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Il 04/05/2011 19:58, Josef Bacik ha scritto:
> +		if (offset>= i_size_read(inode)) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -ENXIO;
> +		}
> +		offset = i_size_read(inode);
> +		break;

I can add that generic_file_llseek_unlocked means *unlocked* so you 
shouldn't unlock any mutex but only return a value. The current version, 
in case of SEEK_END uses directly i_size indeed, so maybe I'm missing 
something.

Marco
