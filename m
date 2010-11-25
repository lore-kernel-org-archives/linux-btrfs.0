From: David Nicol <davidnicol@gmail.com>
Subject: Re: hard links across snapshots/subvolumes are actually a bad idea.
Date: Thu, 25 Nov 2010 03:36:10 -0600
Message-ID: <AANLkTi=sH_m_DMxQnnRu1THP5iaKz7Z-H=8w9fNyFJht@mail.gmail.com>
References: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
 <4CED9FCC.9080804@bobich.net> <AANLkTik7u_eexi++vDCsRh0oa74Q4F1Jjzt_mNn+=MZC@mail.gmail.com>
 <4CEDAB6D.6090409@bobich.net> <AANLkTikW65-Bozsog1exV2G=96DcGR0thSok1NJP4pN9@mail.gmail.com>
 <4CEE178F.6090902@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CEE178F.6090902@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

>> "COW hardlinks" are ref-links (as far as I'm concerned). =C2=A0I sai=
d
>> partially implemented, because that's exactly what a snapshot is. =C2=
=A0I'm
>> just not certain whether bcp works across subvolumes or not. =C2=A0A=
n
>> actual hardlink (i.e., all writes appear in all hardlinks) across an=
y
>> file-system-like-structure (including subvolumes and snapshots) is
>> insane, for the reasons that I'm sure David offered to explain.

Yes. Which side owns the definitive copy? The file system boundary
should stay respected; a symlink will work fine to clearly indicate
where the file is and is not. Applications needing hardlinks can use
mirrored directories. I had gotten the idea that the facility to
create them had been removed due to engineering rather than semantic
causes. Regardless of the history, it makes sense going forward to
respond to the question the next time it comes up with a semantic
answer rather than "we used to have them, but we took them out because
they cause instability due to i-node collisions." Such a semantic
answer would look like "Hard links across file-system-like structures
violate the separation of the volumes: if you really need that, use a
directory instead of a subvolume. (suggest metadata-only copy tool.)
Also, the inode numbers in a snapshot are the same as the inode
numbers in the volume snapshotted, which is a good thing, and they
stay the same even after the files diverge in content."  of course,
edited for precise accuracy.


> My understanding is that inode numbers on the "same" files are differ=
ent
> between snapshots. If that is the case then it is not good enough for=
 the
> use-case I was talking bout. Hard-links share inode numbers. Do ref-l=
inks?

the idea of a btrfs-specific "copy" that simply copies the metadata,
reusing the data blocks -- that's cool -- I'm guessing that's what
"bcp" is, and semantics-wise it should be identical to a
read-and-write-everything copy, and faster than the equivalent on a
deduplicating FS because the reading can get skipped too as well as
the writing. I will look up what "bcp" is and does before the next
time I write to this list.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
