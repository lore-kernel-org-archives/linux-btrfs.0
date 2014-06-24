Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62373 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbaFXBrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 21:47:12 -0400
Message-ID: <1403574116.3826.1.camel@localhost.localdomain>
Subject: Re: [PATCH 3/4] btrfs-progs: delete invalid output file when
 btrfs-image failed
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Tue, 24 Jun 2014 09:41:56 +0800
In-Reply-To: <20140623141557.GG1553@twin.jikos.cz>
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1403142363-29482-3-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140623141557.GG1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-06-23 at 16:15 +0200, David Sterba wrote:
> On Thu, Jun 19, 2014 at 09:46:02AM +0800, Gui Hecheng wrote:
> > When btrfs-image failed to create an image, the invalid output file
> > had better be deleted to prevent being used mistakenly in the future.
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >  btrfs-image.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/btrfs-image.c b/btrfs-image.c
> > index 549722c..b235b87 100644
> > --- a/btrfs-image.c
> > +++ b/btrfs-image.c
> > @@ -2598,8 +2598,16 @@ int main(int argc, char *argv[])
> >  out:
> >  	if (out == stdout)
> >  		fflush(out);
> > -	else
> > +	else {
> >  		fclose(out);
> > +		if (ret && create) {
> > +			ret = unlink(target);
> 
> The previous value is overwritten and in case of unlink() success it's
> returned as success of main(), which is not true. So a local variable
> has to be used instead.
> 
Yes, I'll rework & resend it soon. Thanks.

> > +			if (ret)
> > +				fprintf(stderr,
> > +					"unlink output file failed : %s\n",
> > +					strerror(errno));
> > +		}
> > +	}
> >  
> >  	return !!ret;


