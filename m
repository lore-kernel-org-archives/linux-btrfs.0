From: cwillu <cwillu@cwillu.com>
Subject: Re: hard links across snapshots/subvolumes are actually a bad idea.
Date: Wed, 24 Nov 2010 18:31:06 -0600
Message-ID: <AANLkTikW65-Bozsog1exV2G=96DcGR0thSok1NJP4pN9@mail.gmail.com>
References: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
	<4CED9FCC.9080804@bobich.net>
	<AANLkTik7u_eexi++vDCsRh0oa74Q4F1Jjzt_mNn+=MZC@mail.gmail.com>
	<4CEDAB6D.6090409@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CEDAB6D.6090409@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

>>> One thing I would like to see is copy-on-write hard-links. The hard=
-links
>>> that span snapshots should be possible, but they should be copy-on-=
write,
>>> i.e. as soon as hard-linked file that spans snapshots is written, t=
he
>>> snapshot that wrote it should have it's own forked copy henceforth.
>>
>> There are sym-links, hard-links, and ref-links. =A0Cross device syml=
inks
>> are trivial. =A0Cross device hardlinks are evil. =A0Cross device ref=
-links
>> are just plain smart (and are at least partitially implemented in
>> btrfs; =A0does bcp work across subvolumes?). =A0:)
>
> Last time I asked a similar question, there was no equivalent thing t=
o COW
> hard-links, across snapshots or otherwise. Hard-links spanning physic=
al
> devices don't make sense. Hard-links spanning snapshots, however, do.=
 In
> fact, I would intuitively expect that a snapshot contains only COW
> hard-links which would get COW-ed from both the head and the snapshot=
=2E

"COW hardlinks" are ref-links (as far as I'm concerned).  I said
partially implemented, because that's exactly what a snapshot is.  I'm
just not certain whether bcp works across subvolumes or not.  An
actual hardlink (i.e., all writes appear in all hardlinks) across any
file-system-like-structure (including subvolumes and snapshots) is
insane, for the reasons that I'm sure David offered to explain.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
