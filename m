From: <remi.urbillac@orange-ftgroup.com>
Subject: RE: snapshotting - what data gets shared?
Date: Thu, 15 Jul 2010 10:50:49 +0200
Message-ID: <11210_1279183851_4C3ECBEB_11210_61375_1_EABF98D1E9AEBB48A74724A0F1D9E8C71B8677CC26@PUEXCB2A.nanterre.francetelecom.fr>
References: <AANLkTimYETjLEEIp2vW096vX0IYVFbA5cFRaK_avpMv-@mail.gmail.com>
	<20100714221301.GA5663@flcl.lan>
 <AANLkTinkQH8JOMSFS0F1TbOkDi0bSlEI-mtJRJs4vzex@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: Mathijs Kwik <bluescreen303@gmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinkQH8JOMSFS0F1TbOkDi0bSlEI-mtJRJs4vzex@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,=20

Just to be sure :=20
LVM snapshots are not COW. They are Copy On First Write.=20
The first time you update one block, the original data needs to be stor=
ed in the snapshot area.=20

The COW, aka Copy On Write, is not a very "good" name, because it can l=
eads to confusion. In fact, the copy means that if you partialy update =
=20

-----Message d'origine-----
De : linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.k=
ernel.org] De la part de Mathijs Kwik
Envoy=E9 : jeudi 15 juillet 2010 10:01
=C0 : Mathijs Kwik; linux-btrfs@vger.kernel.org
Objet : Re: snapshotting - what data gets shared?

thanks, sounds very promising

On Thu, Jul 15, 2010 at 12:13 AM, Sean Bartell <wingedtachikoma@gmail.c=
om> wrote:
> On Wed, Jul 14, 2010 at 11:27:39PM +0200, Mathijs Kwik wrote:
>> Hi all,
>>
>> I'm used to snapshots with LVM and I would like to compare them to b=
trfs.
>>
>> The case I want to compare is the following:
>> At the moment a snapshot is created, no extra space is needed (maybe=
=20
>> some metadata overhead) and all data is shared between the original=20
>> and the snapshot.
>> In LVM, snapshots work at the block-level, so any changes done to th=
e=20
>> original volume trigger a COW to the snapshot.
>> If LVM is configured to use 4Mb blocks (default), this means that=20
>> overwriting a 100k file, will lead to 4Mb "snapshot data" to be=20
>> backed up.
>> A 800Mb file will take around 800Mb.
>> So, for small files (that are not on the same extent/block) this can=
=20
>> waste quite some space, while for bigger files, or lots of files=20
>> "close" to each other, it doesn't matter much.
>>
>> How is this for btrfs snapshots?
>> Do they work at the file-level? or also at blocks/extents?
>>
>> I mean, does changing a 100k file lead to 100k being snapshotted?
>
> Btrfs CoWs file extents, and files can use only the parts of an exten=
t=20
> they need, so a 1-byte change would only require one additional 4K=20
> data block. Of course, metadata also needs to be updated, and will=20
> require a number of additional blocks.
>
>> What would happen if I have a 20G file (for example a disk image for=
 kvm)?
>> Would minor changes in that file lead to the entire 20G to be COWed/=
"backed up"?
>
> No, only the relevant portion.
>
>> Is there a distinction between data and metadata?
>> Or does touching (ctime/mtime) or visiting (atime) a file cause it t=
o be COWed?
>
> Metadata is CoWed separately, so there will still only be one copy of=
=20
> the data.
>
>> Thanks for any info on this.
>> Mathijs
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in the body of a message to majordomo@vger.kernel.org More majordomo in=
fo at  http://vger.kernel.org/majordomo-info.html

*********************************
This message and any attachments (the "message") are confidential and i=
ntended solely for the addressees.=20
Any unauthorised use or dissemination is prohibited.
Messages are susceptible to alteration.=20
=46rance Telecom Group shall not be liable for the message if altered, =
changed or falsified.
If you are not the intended addressee of this message, please cancel it=
 immediately and inform the sender.
********************************

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
