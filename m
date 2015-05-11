Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbbEKLXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 07:23:20 -0400
Date: Mon, 11 May 2015 13:23:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs-progs: improve troubleshooting avoid duplicate
 error strings
Message-ID: <20150511112318.GL23255@suse.cz>
Reply-To: dsterba@suse.cz
References: <1428928621-8001-1-git-send-email-anand.jain@oracle.com>
 <20150414131444.GQ25622@twin.jikos.cz>
 <554C73A8.1030406@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <554C73A8.1030406@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 08, 2015 at 04:28:24PM +0800, Anand Jain wrote:
> >> @@ -187,7 +187,7 @@ static int cmd_rm_dev(int argc, char **argv)
> >>   			ret++;
> >>   		} else if (res < 0) {
> >>   			fprintf(stderr,
> >> -				"ERROR: error removing the device '%s' - %s\n",
> >> +				"ERROR: ioctl error removing the device '%s' - %s\n",
> >
> > The only difference is the strerror vs btrfs_err_str. As both ret > 0
> > and ret < 0 report some kind of error, the wording would be very similar
> > so I think that one error message would fit better. I'll fix that.
> 
> You means res not ret (above) ?

Oh right, please send a patch.
