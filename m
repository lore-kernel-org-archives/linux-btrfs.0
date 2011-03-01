From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: btrfs wishlist
Date: Tue, 1 Mar 2011 19:35:42 +0100 (CET)
Message-ID: <28499638.308.1299004542529.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

Having managed ZFS for about two years, I want to post a wishlist.

INCLUDED IN ZFS

- Mirror existing single-drive filesystem, as in 'zfs attach'
- RAIDz-stuff - single and hopefully multiple-parity RAID configuration=
 with block-level checksumming
- Background scrub/fsck
- Pool-like management with multiple RAIDs/mirrors (VDEVs)
- Autogrow as in ZFS autoexpand

NOT INCLUDED IN CURRENT ZFS

- Adding/removing drives from VDEVs
- Rebalancing a pool
- dedup

This may be a long shot, but can someone tell if this is doable in a ye=
ar or five?

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de fleste ti=
lfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
