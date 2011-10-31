From: David Sterba <dave@jikos.cz>
Subject: Re: Patches for BTRFS (mail-server slow down in 3.0 and more)
Date: Mon, 31 Oct 2011 15:30:27 +0100
Message-ID: <20111031143027.GD19328@twin.jikos.cz>
References: <4EAB270C.60406@malowa.de> <orehxw1kl7.fsf@livre.localdomain> <20111029051206.GB4054@shiny.Mikenopa.local> <or7h3lztbt.fsf@livre.localdomain>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Marcel Lohmann <marcel@malowa.de>, linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <or7h3lztbt.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2011 at 02:19:18AM -0200, Alexandre Oliva wrote:
> On Oct 29, 2011, Chris Mason <chris.mason@oracle.com> wrote:
> 
> > The last one isn't a bad idea, but please do make a real mount option
> > for it ;)
> 
> Like this?

@@ -195,6 +195,7 @@ static match_table_t tokens = {
        {Opt_subvolrootid, "subvolrootid=%d"},
        {Opt_defrag, "autodefrag"},
        {Opt_inode_cache, "inode_cache"},
+       {Opt_nocluster, "nocluster"},
        {Opt_err, NULL},


How about 'no_alloc_cluster' ? Or something suggesting it's related to
allocation. At least we're not in situation of ocfs2 where are clusters in
block-gouping- but also host-grouping sense, so I'm fine with nocluster. Just
in case somebody has a better idea for the option name.


david
