Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38346 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGZKFP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jul 2014 06:05:15 -0400
Date: Sat, 26 Jul 2014 11:05:03 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help with Project on brtfs wiki
Message-ID: <20140726100503.GF31950@carfax.org.uk>
References: <CAPDOMVhpnjz32sdEuxLKgZcjYX35eTpG0C8vAjKPNhWMrow9ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
In-Reply-To: <CAPDOMVhpnjz32sdEuxLKgZcjYX35eTpG0C8vAjKPNhWMrow9ng@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 25, 2014 at 07:16:19PM -0400, Nick Krause wrote:
> I am new so I think this project,Implement new FALLOC_FL_* modes needs
> more information for me to
> write if for you guys.

   So you've ignored most of the advice I sent you in my last mail.
Have you even made a btrfs filesystem yet and seen what it can do?
(I'm willing to bet the answer's "no", because you haven't asked _any_
of the common questions about the filesystem yet). You're leaping into
the kernel work without understanding what it is you're working on.
How will you be able to test your work properly if you don't
understand what the user experience is like? How can you test, for
example, the behaviour of your patch in the presence of snapshots, if
you don't know how snapshots should behave? This will take time and
effort to learn. You cannot simply jump straight in to writing code if
you don't understand the basic behaviours of the thing you're
changing.

> I am wondering what is fallocate and how you
> want me to write this, define statements
> or as functions in a certain file?

   This is the wrong question to be asking. If you can't find the file
that fallocate is implemented in in btrfs, then you're simply not
putting in the necessary effort (hint: grep). Similarly, how it should
behave is also trivially discoverable (hint: man, also read the "SEE
ALSO" section). I've already directed you at the basic documentation
for btrfs internals.

> I am not asking to hold my hand

   You are, though. Something like using grep to find code that (might
be) related to the thing you're trying to work with is _fundamental_.
You should expect to be reading the code -- several layers deep, in
both directions from any given function -- in order to understand what
it does and how it fits in, and what problems you might enncounter if
you change it. If you won't put in that degree of basic effort, then
you won't get very far.

   Further, "how should I change it?" is _your_ decision as the
developer of the patch. This is most of the difficulty with writing
code. The mechanics of the code itself is usually easy. Working out
the underlying algorithms and processes is the hard part, and is where
quite a lot of the effort goes in. Asking someone else "can you tell
me what code to write, and I'll write it for you" is pretty pointless,
because if they give you the process in enough detail that you can
"just write the code", they might as well have written the code in the
first place.

> just point me to some documentation somewhere
> and I will read it when I have time as I am working on directory speed
> work for ext4.

   This implies that you've also ignored the advice given to you on
linux-kernel, to pick one subsystem and learn that in detail. You
can't sensibly, as a newcomer to the kernel, learn *both* ext4 and
btrfs in parallel.

   So, again:

 * Set up several btrfs filesystems with different configurations. Use
   VMs for this (because you'll need a VM to test your changes anyway).

 * Read the user documentation on the wiki.

 * Play with your filesystems, work out how the FS behaves -- *in
   detail*. Read the FS features on the wiki and try at least some of
   them out. Use this to understand how it should behave. In
   particular, the semantics of snapshots, and the difference between
   a hardlink and a reflink copy. You will need that later. Ask
   questions (detailed, targetted questions that show you know the
   difference between what you know and what you don't).

 * Read the developer documentation. Again, ask _useful_ questions
   (see below).

 * Improve userspace in some way. I'm serious about this -- it's less
   critical if something goes wrong, and we have more people who can
   review the patches while you're getting used to the code.

 * Then, and *only* then should you start digging into the kernel
   code. Read the developer documentation again. Use btrfs-debug-tree
   to inspect the contents of a filesystem and work out how it fits
   together. This is *not* optional. When you get to that point, and
   understand how the on-disk structures fit together, then we can
   talk more about suitable approaches for whatever code you want to
   write.

   Finally, on the subject of asking useful questions: Questions such
as "tell me where to start", or "how do you want me to write this?"
are bad, because they demonstrate that you have put in absolutely no
thought of your own. You don't have an opinion of your own, and you're
effectively acting as a completely passive element. This means that
you're a net time-sink, and with that attitude you're unlikely ever to
produce a positive overall effort in the project.

   Instead, you should be doing as much as you can to learn about the
system on your own. We have quite a lot of documentation on the
user-visible behaviour of the FS. We have documentation on data
structures. We have some documentation on the core tree-manipulation
functions. Read that, understand it. Look at the code and see how it's
implemented. Start asking _yourself_ the questions of "if I want to
achieve this effect, what does the FS need to do? What behaviour would
need to be changed, and how?". When you think you have an answer to
those questions, you can start having a real and useful conversation.
You will probably be wrong, but that's where the process starts, and
you will get better at it over time. If at some point there's
something you don't understand, do ask, but make sure that you can say
what you think you know, and why you can't understand the thing you
are having trouble with. Think of the person responding to the
question: Make it easy to write the reply by ensuring that the reply
can be as short as possible. Some of the time, you will actually
answer your own question by trying to ask it in a sensible way. If you
find that happening, you're asking sensible questions.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I must be musical:  I've got *loads* of CDs ---           

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU9N9T1heFHXiqx3kAQIpGxAAlrzq8ni25xFySdluGfUU90rdx3JFfVsz
72WeXfDPGVob736BIwhwUWJ0cBAPUVPOaEcLtjicvZ8wuYndcFnvf7ZwZs6TIIqB
DsDxcTYlANgDqFZXLXYtFglatbJLGrwZ+LK9YmlOSTKXiHiOfmHg9rK3Bzga+O7K
sd5GuccS8WP48AH4KjZH9kApt+h1nYMZgOlAtJkVoK41w1v5tDRzUja7S8QTapnD
dm9YE/gO5n3OP/W0JVLrVa7TFzzKIQPyHES0xa7/LZyZbUTwQNNSwJoaAFQuIty4
TGFectZorOqcmEeoTOJxU+NP0wu+d51+EawvRlQ919UhgAt5SOthPCrssjkZoHDL
LSLbi2M6R0o3Ug29JEA4t+a901nM1netMm3zw0XiKGENDDl8J3sjYmWWrloda8A7
ITdPh7Ru6wp+PztTJhaQhARObNIBwL1WmKhbi+LR/EJh246GjnNHKQ2tueE5diOQ
jGUx4bxvpqbgqRsyMVZZoFz//Tqr652V6cIsOSnNyXthBcGRgO9tG+vWg3PqULYX
DPLighadZKfwfHQODbV58cgsFOdgRPrc36U/SrPh5nfsPmjqlArODquYnpxmuhZF
HODQrNhh1twEXJyDWB8/ytZ3frb4VCaE0ZSA4eGoPAT+dM3Fg3k3XmsnN52whqoq
qhOJme4paZA=
=lC6b
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
