From: Yeh <ykwan0201@gmail.com>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Wed, 24 Aug 2011 07:26:15 +0000 (UTC)
Message-ID: <loom.20110824T083328-979@post.gmane.org>
References: <4E19611D.2090007@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen <sensille <at> gmx.net> writes:

> 
> These 4 commands are used to build hierarchical qgroups and are only
> for advanced users. I'll explain more of the concepts in a later
> paper.
> 
> The main point here is that in the simplest case, a user creates a
> filesystem with initial quota support, creates his /var /usr /home
> etc. subvolumes and limits them with commands like
> 
> btrfs qgroup limit 10g /usr
> 
> That should be simple enough for the common use case.
> 
> -Arne
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Hello Arne,

There are some discussion in mailling list topic "What to do about subvolumes".
It is copy-on-write quota counting.
One is charged the quota as physical blocks count.
Another is charged as how much the user looks like.
Both of them have different limitation.
What solution would you use?

The topic you mentioned is what I need. How is your btrfs quota implementation
progress? You could release your patch for me if possible, I can join your idea,
design and implementation. I have large disk array for testing.

Best regards,
Yeh.


