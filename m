Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:38574 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946728Ab3BHSRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 13:17:15 -0500
Date: Fri, 8 Feb 2013 19:17:13 +0100
From: Ian Kumlien <pomac@vapor.com>
To: kreijack@inwind.it
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20130208181713.GO15780@pomac.netswarm.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
 <51153846.7020304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51153846.7020304@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 06:39:18PM +0100, Goffredo Baroncelli wrote:
> H Iam,
> 
> On 02/08/2013 01:36 AM, Ian Kumlien wrote:
> > This patch includes the functionality of btrfs, it's
> > found as "btrfs check" however it makes the binary
> > behave differently depending on what it's run as.
> [...]
> 
> >  
> > +static int cmd_dummy(int argc, char **argv)
> > +{
> > +	return 0;
> 
> I think we should warn that fsck.btrfs does nothing. Something like:
>  +	fprintf(stderr, "WARNING: fsck.btrfs does nothing. "
> 		"Try 'btrfs check'\n");

Yes, will do, perhaps not a big warning but atleast alert the user to
the fact.

> > +}
> > +
> > +/* change behaviour depending on what we're called */
> > +const struct cmd_group function_cmd_group = {
> > +	NULL, NULL,
> > +	{
> > +		{ "btrfsck", cmd_check, NULL, NULL, 0 },
> > +		{ "fsck.btrfs", cmd_dummy, NULL, NULL, 0 },
> > +		{ 0, 0, 0, 0, 0 }
> > +	},
> > +};
> > +
> >  int main(int argc, char **argv)
> >  {
> >  	const struct cmd_struct *cmd;
> > +	char *called_as = strrchr(argv[0], '/');
> > +	if (called_as)
> > +		argv[0] = ++called_as;
> >  
> >  	crc32c_optimization_init();
> >  
> > -	argc--;
> > -	argv++;
> > -	handle_options(&argc, &argv);
> > -	if (argc > 0) {
> > -		if (!prefixcmp(argv[0], "--"))
> > -			argv[0] += 2;
> > -	} else {
> > -		usage_command_group(&btrfs_cmd_group, 0, 0);
> > -		exit(1);
> > -	}
> > +	/* if we have cmd, we're started as a sub command */
> > +	if (parse_one_exact_token(argv[0], &function_cmd_group, &cmd) < 0)
> > +	{
> > +		argc--;
> > +		argv++;
> >  
> > -	cmd = parse_command_token(argv[0], &btrfs_cmd_group);
> > +		handle_options(&argc, &argv);
> > +		if (argc > 0) {
> > +			if (!prefixcmp(argv[0], "--"))
> > +				argv[0] += 2;
> 
> I can't understand the reason to skip '--' ? But this question is not
> related to your patch...

it handles, it seems, btrfs --filesystem or so, if users are unsure of
usage, more like mdadm in that respect

> > +		} else {
> > +			usage_command_group(&btrfs_cmd_group, 0, 0);
> [...]
> 
> -- 
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
