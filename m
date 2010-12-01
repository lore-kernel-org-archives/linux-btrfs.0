From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: dynamically remove unused block groups
Date: Wed, 1 Dec 2010 03:11:32 -0500
Message-ID: <20101201081132.GC427@dhcp231-156.rdu.redhat.com>
References: <1291135590-26775-1-git-send-email-josef@redhat.com> <AANLkTikkU_2SbtVzRuUJbTGO3dQGQc9Jd8FgpGFPF7uE@mail.gmail.com> <20101130190100.GA2577@localhost.localdomain> <AANLkTik7ypX9Ed+pngnjHB8CrKDMJK-F+HXhbK3MrhZ0@mail.gmail.com> <20101130193512.GB2577@localhost.localdomain> <970f54e0098c313a4b780b2356734592@arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <970f54e0098c313a4b780b2356734592@arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 30, 2010 at 09:53:41PM -0700, Anthony Roberts wrote:
> Hello,
>
> What happens in the event the filesystem has mostly been cleared out,  
> but there's a few things left? For example, several of the chunks might  
> be at very low usage, but not zero. Would the user be able to defragment  
> the filesystem to cause these chunks to be consolidated?
>

Yeah thats what balance is for.  Thanks,

Josef
