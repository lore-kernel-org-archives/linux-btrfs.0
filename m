From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: [PATCH] Btrfs: dynamically remove unused block groups
Date: Tue, 30 Nov 2010 21:53:41 -0700
Message-ID: <970f54e0098c313a4b780b2356734592@arbitraryconstant.com>
References: <1291135590-26775-1-git-send-email-josef@redhat.com>
 <AANLkTikkU_2SbtVzRuUJbTGO3dQGQc9Jd8FgpGFPF7uE@mail.gmail.com>
 <20101130190100.GA2577@localhost.localdomain>
 <AANLkTik7ypX9Ed+pngnjHB8CrKDMJK-F+HXhbK3MrhZ0@mail.gmail.com>
 <20101130193512.GB2577@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Cc: <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101130193512.GB2577@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

 Hello,

 What happens in the event the filesystem has mostly been cleared out, 
 but there's a few things left? For example, several of the chunks might 
 be at very low usage, but not zero. Would the user be able to defragment 
 the filesystem to cause these chunks to be consolidated?

 Regards,

 -Anthony

> Yeah 2 things to keep in mind, 1 if you have snapshots you are likely
> to not see
> data free'd up the way you expect it.  The other thing is that 
> because
> everything is COW we can't allocate the newly free'd space until the
> transaction
> commits, so you may have to wait ~30 seconds or run sync to force the
> transaction to commit before you see your space actually free'd up.  
> Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

