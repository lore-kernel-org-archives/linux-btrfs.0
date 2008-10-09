From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: Question about e8569813849b5da394a195c7e76b4faa452b12d1
Date: Thu, 9 Oct 2008 09:47:41 +0800
Message-ID: <3d0408630810081847q205c1fe2q227e9e3c7b92fc2@mail.gmail.com>
References: <20081008205947.GA18375@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081008205947.GA18375@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2008/10/9 Josef Bacik <jbacik@redhat.com>:
> Hello,
>
> Is there a reason
>
> -       if (search_end == (u64)-1)
> -               search_end = btrfs_super_total_bytes(&info->super_copy);
>
> happened in the commit from $SUBJECT?  If its just a mistake thats fine I'll add
> it back with my current patch, but if there is a reason it needed to go then I
> need to know that too so I can figure out a different way to do what I want to
> do.  Thanks,
>

btrfs_super_total_bytes is total size of all devices. we can't rely on it as
search_end for two reasons:

1) If metadata mirror is enable, the value can be larger than the last byte of
    last chunk.

2) For a FS has been balanced, there are some 'holes' in the chunk address
    space, so the value can be smaller than the last byte of last chunk.

Regards
Yan Zheng
