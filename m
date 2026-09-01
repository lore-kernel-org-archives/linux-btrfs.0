Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67A39C63E;
	Tue,  1 Sep 2026 01:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788224744; cv=none; b=jnLhdjehEPF1QzEEY+x66Bqaa7BV21iMVBTm05F834Dr+G26HX0e0N8+owc1IYLMME/4Hv5GuemhFYBXPHKOT3MEbAUFKJpuxnWNYh22UlNcH5fskq5RZq+tOZG1I2IXUn2DEIPElRWciWFZG+MB39uUmgkoB6FKG0Jp+uMP6B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788224744; c=relaxed/simple;
	bh=mNXkOSz98/+UGGBc12TmJn5JJf91GdVv10hWED2G2II=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=EHiNgLBbImsH1u8uz/URJZwPDF1gHQyTuA5stTVb+Y5i1w9mL5AX64GmyqIgFE28CiRcvHK5P5NgeMg7iHmVLjseCDPzOzuIQjz2HwcYaQJJfYLQFEOf8kVbN/5pnSqDSngyUvewTRM4shM40jPtWyRCUd45rSiQYLzUoc72SZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=FwdPMQNa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UiY0GemD; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="FwdPMQNa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UiY0GemD"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DEB757A01E6;
	Mon, 31 Aug 2026 21:05:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Mon, 31 Aug 2026 21:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1788224740; x=1788311140; bh=AYUO9MYad2Pb0mKD7jsXonSb8PKwnAjvohW
	y316UVXo=; b=FwdPMQNaeIOXcQJxcIrFdOG9zStFQy+mM9YSdVK0Yp1UR+CEfEn
	K7gov0xQcuhrVr8PYdnjx3XdWZSrQur/Mgx9OQ5Otg80tAf/grUGVBV63cbmi5FP
	EgcqlGjzpDRa2SUmz1npxiUO24OC2Ui7B837YSxsI+XkqFbUaLrzue+BK5SbHxpJ
	zvZ4BelReftHnTkP7yD2h2Rdf5pw5L/rhJNUaQ4ZwokeD84hNxhNwkRBP5MXW03j
	vujSuCcGjfrG2BVueZMKwzagIDrcSzBV0XXhAjdGSSuK1ygoviHfzFaJBxiTInh/
	70aW10Q5cnw/sYqzpg6xGVv9yUv8adwaemQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788224740; x=
	1788311140; bh=AYUO9MYad2Pb0mKD7jsXonSb8PKwnAjvohWy316UVXo=; b=U
	iY0GemDs9SOfz9JSAe6vxwtu/VMRzCqaK7rgacNniQoCariZ1iUJnGPBDuBozDWm
	NNr1eXVySYluHTMhLoyQPQIzOcNsB1Dof9tK3BIWNkdVZ0S6BZ2+U66OfWCraGco
	DiqH38fUnSAwFp4c8AJ/1z3T12l8cv6IN2aYy/KtIYDUF5ictaqknRHZgWWOXWpo
	+4uit8Hm3QGC5sQ01Zc/PX/OvY37384fCcTd6M6soi0+p5L2WvLx20pNlBy9BU9D
	y9S/LP4Gp7vG/ceWurwwKnF3JrGxi9g+C8lzExYkdFfvTjdOFqj+kAZZFIMzqtX2
	jTdrYxs5vw/VPs6w8gJWQ==
X-ME-Sender: <xms:5CSWalo09blrkLKQsCJiUED97KBuBYIivu70INfCqK5w7UceG-0BTw>
    <xme:5CSWailFmFjAZkCzZydxsOMV7naZCjW6SmAG2EuA3YyNaFED4sYNnVRTPwNHLSagz
    jGftOiPTNAfZevVp7sLD8J_M1WjrYaHb8SWrab6W8wk6u6TQ3g>
X-ME-Received: <xmr:5CSWahO_zOSftKT3q0vnV84g1TJQ6muoAeKuyxAQtRvcYzk6N4PuZjg9bOMS4ikekV55haclK1GcLIjkBdHKFkvsf2RmStE>
X-ME-Proxy-Cause: dmFkZTF/Gq538FWQLudr0dvEy1gpH0cdfcKMtZj3eSalrSBh07NpjJhnxNQ4cu1PERrL+v
    8QA4In15YQ/l/xehsnlWGgPr837V9Rxllsbge8kJj9dlJpjt/xhPzNd+qj0xOVHIWEQOda
    ojJnycv+2MprJ33FGn6JB/CscivK3tytLRv+hc4VPVFlyZqoVwyKnGbWqAwJN5mX4biecJ
    srgr28iLyg6Tw8GGS3HbQywNJFodTYzionhxeKQsYaD3x+2GkoIEd8ng2fIhrn/AfSKipK
    ruedo98oFlleozM/Xgc1xpmefDWgFQQrm5t3p8OpH+fxglKqdRJos+hvd0FH6UElWn6hrS
    4RVGju/q1b0iCka3prRb7NbTyiUx1CZVP9Fj1laEa4kO203rw3/2/Uk0l5ZyD28jYN5dgt
    q99iZST0wsn7sWxDojrXv7KYvgi8RKQnudOUz5qUiKOXwF2bMf0L9CXZ/s56K8KJC3y+EO
    VFJXzKQQ7NX5iDkY+UkEHDH00gF4qtxdsHY63Mvoy7Czs0xykVoXqaDpjfPpaRlF7kfy1b
    Gx2e4jD2iE0woLvUgUPwiH1QcwFXO2uJaM083ndHe1cSD8HuSnv9J2BQxKrzAqi7AAeUmh
    6C5hut0O4z/hx5f7wkRhEWuKcfTKc5TuC2G58pghtEOhKoKc4dWMrP9UKkCQ
X-ME-Proxy: <xmx:5CSWamNxKv1QE3oCfpWcKLKnm37nSA-Ya8xVVhWlXE_BKxEDrZedkQ>
    <xmx:5CSWaigVeTkFdNL-wR-pN-IDw5f4p9ZLjT-xbUJz0i_NwgsV2Ahmzg>
    <xmx:5CSWajtgHwGQ2ns-oN8qSmWy45Y_U5UwwzWxBgFwnU4GtO0q99a1pQ>
    <xmx:5CSWaoTP6dKRIN24ECMJqwCxdp87kxkhEdP6UazuegG1gA2sDIsJ1g>
    <xmx:5CSWavtnnx9pOtkK6-kJySGc-e0cFGcs2agWPgU9uT8t7TI73iu43rJu>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 21:05:38 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Matthew Wilcox" <willy@infradead.org>, fstests@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Chuck Lever" <cel@kernel.org>,
 linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Add test of seek in directories
In-reply-to: <apV-omM4s58KtkRz@infradead.org>
References: <20260827234743.2389778-1-neilb@ownmail.net>
  <20260827234743.2389778-2-neilb@ownmail.net>
  <apEK5uirjyLZUfmA@casper.infradead.org>
  <178791556100.3510150.18132687067056760170@noble.neil.brown.name>
  <apV-omM4s58KtkRz@infradead.org>
Date: Tue, 01 Sep 2026 11:05:35 +1000
Message-id: <178822473504.3510150.6373190942920919075@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Mon, 31 Aug 2026, Christoph Hellwig wrote:
> On Fri, Aug 28, 2026 at 09:12:41PM +1000, NeilBrown wrote:
> > If you happened to know the sizes of the all the names in the directory,
> > you could make a sequence of getdents calls which each return precisely
> > 1 entry,  You could then use lseek to determine the seek offset at every
> > point.
>=20
> No, you can't.  Despite the historic naming d_off is not an offset, but
> a cookie.  You can not arithmetics on it.
>=20
> > Linux getdents64 makes this a bit simpler by returning exactly that same
> > number (the seek offset to the next name) in the d_off field.
> >=20
> > So posix certainly allows, indirectly, seeking to each d_off.
>=20
> Posix and Linux allow to seekdir to each cookie returned from telldir,
> it does not allow to do arithmetics on it.

I agree. No arithmetic, but seek is allowed.
The cookies should all be unique across a single readdir pass, and none
of them may be zero as d_off is a seek address *after* the current name,
and the seek address zero is *before* all names.

>=20
> >=20
> > Posix refers to one directory entry "immediately following" another
> > which clearly implies a well defined sequence (if you exclude names
> > added and removed during the read).
>=20
> I think you're talking about posix_getdents here, which isn't really
> Posix as we know it, but was added in the 2024 edition without actually
> having relevant implementation so far.  It does however implement
> the syscall-level API in most modern Unixes.  It does not mention
> d_off at all, just the lseek-able file offset, though.

The d_off provided by Linux is precisely a seek-address with a
granularity of one name, rather than a granularity of one getdents call.
This is implicit in the VFS implementation.

>=20
> > I think a strong argument for Linux needing something is that NFS needs
> > working directory offsets to be able to support READDIR, because there
> > is no "OPEN" request for directories.
>=20
> I don't think anyone disputes the need for stable directory offsets,
> and we should (*knock on wood*) have implementation of native
> file systems that fail this.

"should not" ??

>=20
> What the test tries to force is a specific behavior for rename onto
> existing file names, replacing the original file name entry with
> a new one of the same name.  The test expects that to reuse the
> previous d_off, which is not required by any real or de facto standard.

That's debatable.  The documents that I have found don't mention rename.
Does that mean anything goes, or do that mean it doesn't get an
exemption from the general rule that all names must be listed?

>=20
> > I know less about btrfs.  It appears to always add new names to the end
> > of the directory listing.  When you rename over an existing name, that
> > existing name is relocated to the end.  I can only guess why it might do
> > that.  I have no idea if it "needs" to do that.
>=20
> btrfs doesn't manage freespace for the d_off space (doing so is quite
> complicated and requires a lot of code in XFS for example), so it
> simply uses a monotonically increasing counter for the value reported
> in d_off.  This simplifies things a lot, and should work well on 64-bit
> systems were you are basically impossible to round out of d_off values.
> It might be a lot more problematic on 32-bit systems because the
> seekdir/telldir cookie is a long and not a guaranteed 64-bit value.

I think that always allocating the next unused number when adding a name
to a directory is perfectly reasonable when 64bit seek addressing is
available.  The only question is on whether a replacing rename involves
"adding a name".

>=20
> > Fun fact: This behaviour of btrfs (which I think is perfectly defensible
> > for new names) resulted in generic/736 (which I think is an unreasonable
> > test to impose) which btrfs "fixed" with a mechanism that doesn't work
> > over NFS.  i.e.  it doesn't work if you close and re-open the file for
> > each getdents call.
> > If I mount a btrfs filesystem over nfs with rsize=3D4096, then generic/736
> > fails.
>=20
> That code and the tests looks a bit questionable, as readdir by
> definition can't every complete in other file systems either if you add
> new entries faster than the pace of readdir calls.  I.e. if you replace
> the rename there with link calls adding new entries you run into the
> same issue with every file system.

According to
  https://www.spinics.net/lists/linux-btrfs/msg138653.html
this seem to come from
  https://github.com/landley/toybox/issues/306
which suggests that

  toybox find testdir -type f -print0 | xargs -0 -n1 sed -i s/a/b/=20

runs forever on btrfs.  Certainly this is unexpected behaviour.  Should
it be fixed in the filesystem or in toybox/find?

I can understand toybox wanting to be as simple as possible.  But
readdir() doesn't make any promises about terminating.

I wouldn't object to btrfs "fixing" this by never reporting new names
except that:
 1/ the interaction with rename/replace is problematic
 2/ the current fix doesn't work over NFS.

I think the rename issue can be fixed by simply reusing the existing
offset when reusing a name.  I might try a patch if a find some time.

I think a fix to make it work over NFS would be to report the entries in
reverse order - most recently added to least recently added.  This would
effectively encode the timestamp (last_index) in the seek cookie instead
of in btrfs_file_private.
Changing how the seek-cookie is interpreted could cause a hiccup
for an NFS client which was in the middle of a READDIR when a server
we reboot to a new verion of btrfs, but that is likely not significant.

Note that
  https://pubs.opengroup.org/onlinepubs/9799919799/functions/posix_getdents.h=
tml

uses the word "incremented" in=20

  the directory entry immediately following the last entry whose
  information was returned

but I don't think anyone seems interested in that detail.

>=20
> > The link you provided says:
> >   If a sequence of calls to posix_getdents() is made that reads from
> >   offset zero to end-of-file and a file is removed from or added to the
> >   directory between the first and last of those calls, whether the
> >   sequence of calls returns an entry for that file is unspecified.=20
> >=20
> > which unfortunately doesn't cover what happens when a file is renamed.
> > When renamed to a non-existing name, it might be reasonable to describe
> > this as "removed from" and "added to" so its appearance could be
> > unspecified.
> > When renamed to an existing name, I don't think it reasonable to
> > describe the target name a being either "removed from" or "added to" the
> > directory.
>=20
> If we are talking about files, it is very clear that the target over
> which is renamed is removed from the directory.  And if the source
> was outside the directory it also is very clearly added.  The only
> gray area is a source file that already was in the same directory.
>=20
>=20

As I explained in another email, I don't think it is reasonable to
interpret "files" as mentioned in the documentation as "inodes" but only
as "names".  I think the text is sloppy and should be more explicit but
if you uniformly assume "file" to mean "filesystem object" is doesn't
make sense.

Thanks,
NeilBrown
