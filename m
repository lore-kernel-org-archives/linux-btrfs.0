From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Patches for BTRFS (mail-server slow down in 3.0 and more)
Date: Mon, 31 Oct 2011 16:08:32 -0200
Message-ID: <orlis1xcdb.fsf@livre.localdomain>
References: <4EAB270C.60406@malowa.de> <orehxw1kl7.fsf@livre.localdomain>
	<20111029051206.GB4054@shiny.Mikenopa.local>
	<or7h3lztbt.fsf@livre.localdomain>
	<20111031143027.GD19328@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcel Lohmann <marcel@malowa.de>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111031143027.GD19328@twin.jikos.cz> (David Sterba's message of
	"Mon, 31 Oct 2011 15:30:27 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

On Oct 31, 2011, David Sterba <dave@jikos.cz> wrote:

> On Mon, Oct 31, 2011 at 02:19:18AM -0200, Alexandre Oliva wrote:
>> On Oct 29, 2011, Chris Mason <chris.mason@oracle.com> wrote:
>> 
>> > The last one isn't a bad idea, but please do make a real mount option
>> > for it ;)
>> 
>> Like this?

> @@ -195,6 +195,7 @@ static match_table_t tokens = {
>         {Opt_subvolrootid, "subvolrootid=%d"},
>         {Opt_defrag, "autodefrag"},
>         {Opt_inode_cache, "inode_cache"},
> +       {Opt_nocluster, "nocluster"},
>         {Opt_err, NULL},

> How about 'no_alloc_cluster' ?

I considered that, too, but choosing the option name was the most
difficult part of the patch :-) I ended up going for the shorter name,
just to get the conversation started ;-) I don't feel strongly about it.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
