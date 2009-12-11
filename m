From: Hu Ruihuan <specter118@gmail.com>
Subject: Re: a question about btrfs_writepage
Date: Fri, 11 Dec 2009 20:00:48 +0800
Message-ID: <713d0d430912110400w3ace4ecbsc764d17a4485d96b@mail.gmail.com>
References: <713d0d430912110356t3ed75c22u3b73fe2a19ed162a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <713d0d430912110356t3ed75c22u3b73fe2a19ed162a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/12/11 Hu Ruihuan <specter118@gmail.com>:
> Hi all,
> =A0I am puzzled about a question, everytime when btrfs_writepage is
> called, whethe the noeds in every levels of the fs tree will be
> updated. This is the case as I read in the code, but if this case,
> whether it will give rise to the low efficiency?
> =A0 Thanks!
>
refer to the update of nodes, I mean a cow operation
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
