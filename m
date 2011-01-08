From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] btrfs: Mem leak in btrfs_get_acl()
Date: Sat, 8 Jan 2011 21:26:13 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1101082124410.17411@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101062242320.13988@swampdragon.chaosbits.net> <87vd21kr0d.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vd21kr0d.fsf@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 7 Jan 2011, Aneesh Kumar K. V wrote:

> On Thu, 6 Jan 2011 22:45:21 +0100 (CET), Jesper Juhl <jj@chaosbits.net> wrote:
> > 
> > It seems to me that we leak the memory allocated to 'value' in 
> > btrfs_get_acl() if the call to posix_acl_from_xattr() fails.
> > Here's a patch that attempts to correct that problem.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> I posted a similar patch long time back.  But never got picked up
> 
> http://article.gmane.org/gmane.comp.file-systems.btrfs/6164
> 
> Message-id:"1279547924-25141-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com"
> 

I see. Was not aware of that.
Ok, since they are identical and yours was posted first, yours should be 
the one merged (if any) I think.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
