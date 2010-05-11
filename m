From: Harshavardhana <harsha@gluster.com>
Subject: Re: rmdir SubVolume?
Date: Tue, 11 May 2010 08:57:23 -0700
Message-ID: <4BE97E63.8070409@gluster.com>
References: <AANLkTin_5GBuC9IzSzoY6hw4brLApJd2FeYfNj6Mo5Jc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Jay Sullivan <notfed@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin_5GBuC9IzSzoY6hw4brLApJd2FeYfNj6Mo5Jc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/11/2010 08:51 AM, Jay Sullivan wrote:
> Hi,
>
> I'm just experimenting with btrfs (am currently using btrfs-tools
> v0.19). I'm curious about deleting subvolume (and snapshot)
> directories.   What exactly is the technical reason why we need a
> special command "btrfsctl -D" to delete these?  What's the obstacle
> preventing "rmdir" from being used on these?
>
>    
rmdir returns ENOTEMPTY as of now, there was a patch which i sent some 
time back to return EPERM to make it more intuitive. I am not sure will 
it be included.

Since there is another idea of actually implementing the btrfsctl -D 
part into "btrfs_rmdir"
itself. Never got much time to look into it.

Regards

-- 
Harshavardhana
Gluster Inc - http://www.gluster.com



