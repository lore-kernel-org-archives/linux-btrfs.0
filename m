From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2 v2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 05 May 2011 15:01:20 -0400
Message-ID: <4DC2F400.4060903@redhat.com>
References: <1304531920-2890-1-git-send-email-josef@redhat.com> <4DC2F24A.4050304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DC2F24A.4050304@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/2011 02:54 PM, Marco Stornelli wrote:
> Il 04/05/2011 19:58, Josef Bacik ha scritto:
>> + if (offset>= i_size_read(inode)) {
>> + mutex_unlock(&inode->i_mutex);
>> + return -ENXIO;
>> + }
>> + offset = i_size_read(inode);
>> + break;
>
> Here maybe it's possible to use offset bigger than i_size, because
> i_size_read is "atomic" but something can happen between two calls,
> isn't it?
>

We're holding the i_mutex so we are safe, i_size_read is used just for 
consistency sake.  Thanks,

Josef
