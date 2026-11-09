Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794232432;
	b=OPidB2I7m86bZPqUmCoEG/Y9tod8D25Su56i+WpOGrhaBhKIzKyLru6iTQBeC/JZGiO5
	 8t6QTA4XhzolVssEcme0rfpfi0DasCsREA2nLGcX7o3Z+vXH/0fJiuIXxtNrWGcMSXU4r
	 azzYzHNf9T/gX8aNxMRzwVThJ9GVx7QEhZc0W+MH9H0uBQedKWtqsrcwmE+Fu6K9ta0+H
	 NcgTLDtRGP7K2mm/an80/NCL19CJVX1RUVfof/NnNfSChoZExac5y/cIgFXYfO6s2svz/
	 cwKnXrhfH9meJIuJFkRkLb4RT58pwy1Fv4TZ9vh+K8ZZ3An8h8JL/IxcB5vbylaKbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232432;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:x-forwarded-message-id:Date:From:To:Cc:Message-Id:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=YgmyJKYzazMVAr2VSmd3tv3sYUr4SgZDZCb6pIS8gRQ=;
	b=FRRIDP+RWA4eDfL+sda7A/I2ujPzd1G0rotk1g3+kaEjGOt7+tTXyZe5xdUlKNZ/4PZw
	 3CCVoXO4XCkP05g9FiMmJN2HsfwnrxfLdE4ensa/AawFAXLGUEWRAiCnhnNxQe9zwAuEd
	 fL7biGt83VnAsuks5/0v0sS/Ts0Mnm7AQDDL+w01TkxzqE58SinlVSGcjzalsAjRYEhQf
	 bQeOwPl4n6O6Mhh+/OwzEkEmNljp/SOcmMHa7N4H2gz7ItUDBmaxMTp/ck7hT3te5r1z9
	 FEQ1kCbc3WBchjWnNXc0RmRF8CpcDl28pyzXZdtgsUo3oLRxz+0UZbpDWPlGroevOOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ampx.net;
	spf=pass smtp.mailfrom=ampx.net;
	dkim=pass header.d=ampx.net header.i=@ampx.net header.a=rsa-sha256 header.s=fm2 header.b=TorDdwun;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=uLNxZecb;
	arc=none smtp.remote-ip=202.12.124.152
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE2606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 13:53:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CFE2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ampx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ampx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ampx.net header.i=@ampx.net header.a=rsa-sha256 header.s=fm2 header.b=TorDdwun;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=uLNxZecb
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7EBDE7A0181
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 08:53:51 -0500 (EST)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-03.internal (MEProxy); Mon, 09 Nov 2026 08:53:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ampx.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1794232431; x=1794318831; bh=Yg
	myJKYzazMVAr2VSmd3tv3sYUr4SgZDZCb6pIS8gRQ=; b=TorDdwunrXRsG9eZv2
	t1TLuk0hDA91R1moBmhI7H43VD2gp9LkN6iz758FK24sUHRWjAQ/jsnXl5UZ5mq/
	zBaf4FixDJTYa+d8eBuKlD4BqUgvUaWh5jKaHL8xod3wTf5eL76zWWTER96Uil8Z
	w2Ii0jnCH6g9qBEg1fg7E/xJNahUhVhLyjkpoAXeXBfWInYWy94BqVN6HMRqzJUI
	EBvZg1FzuLgcYohSzL1sBnbqBC/0Npt68KlTADCN2vhvwr1gpByvgpK2kSCX1o+R
	xx2FVH8GSO6IHOSwn+6shJ+RQWEow/kHeLs05Bp2JkIbDtnfZjuIgBliDA4w48h5
	B1kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1794232431; x=1794318831; bh=YgmyJKYzazMVAr2VSmd3tv3sYUr4
	SgZDZCb6pIS8gRQ=; b=uLNxZecbGhQZ9hxxa6IIecRbW8KpJoJcq+mfrq67bCH1
	njcYIQYD6AMyDl73BlxHsvA+qfkbxAyrcpbHreYI65XgIoiV7veYs6zOM3w9KPD1
	AGNIbjF3ooT6pu7jiSKpabbjvypqmdc3Gj4LP8TDVmA0TdgRefHovwphZXPsNzcO
	M5lovw7AB+bpzNOZ7mE1nqUxqWaNwgzPAcKLyUSAVvxY/3if4RqYJggT374TqIsX
	xgxWTy6is97GOd0eXm4qEd8r4r5QUKxMuy2CSfYEs7Nc8ghzIJrLLqj16IRRAHQk
	tmhIheRzSmcmZrlbULkzKbCCfcibV+g2HqzVWgXBsQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ampx.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794232431; d=ampx.net;
	mf=PHN0ZXJsaW5nQGFtcHgubmV0Pg==;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm2:rsa-sha256:Ux9vsRiGQD+b3ZTZYEboxB1ZP/G17Pt/AD5U5li0dFwaG5b
	j0VqmmGaI3+ehNSxiqLSNF9J9zO/hKFv5xwyjmce0jV2iukVAfvPqxBT/bpgul9j
	H4UX8Xs1Cqr7Q1ajyPVbrrQ1nBYsiStJMs56Z76YyiidlvsvLyNDCTub7qzmpKLE
	tWY55gu++m1OBDc3EsObHNOMssHIja0wylEBFbXoHSoMFiZ/0IV0t7qd0sD3loBD
	DaFwS3VOpEV7lUQDIFrgnvMSq9c7S5NIRPF3fkZZ/9LV8OZl87aE3mYJogkRaQww
	X9LGaszjbT8Lct+VMaRtcyPviEArWpAgelH2t0g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:cbkLc8yMnmGdqTD/sOGuqb60u9J9DuJUQ9277EoNV30=:JAN3KnoybojFhMBkuQ5g+Ogq1+EH0HPUl63q2R03xHM=;
X-ME-Sender: <xms:btDxaqTrEsQGknOrpz8vIElf8fjjC4blfa4-AMNk4Zd1mMdJKcBgng>
    <xme:btDxaqmAgsqNBNYygfI4MFArjV0MRXSdfQO5B3SxRsDQjUMoNfTAu3fQfwSZCBrqT
    MACIUWB5CBC3Cmv8gnuFu1-1R4F3UQwVg02aaDY3BsGaNdm43IqSBwZ>
X-ME-Proxy-Cause: dmFkZTGlOoGrfKU3dS/b55BVlUkpbFQzWdZqWrcQXNR2jNlHMYVshB3J9GpUW8RSLCjCi0
    pTDYhwiVYEc1TNe3V4OdvgzW+zwkxzeZTE/LQVeBq0u6MdItCNmOz5MOgpIqWbJgO+V6qm
    yCH6Vns17N8iHLazfQspm4X0oPREfcA5tSI+JYJ+EC5Nync2IO6/uTvr5FLat+93heGIjR
    yIqj7hL1k3NEei1vBqgrNfFpcHf2cwbfWqkI8Fy2L9e35h87ndmtyR57sQ2ZI1bkr/FGSV
    tYMm7ZU6axFNW2Pj2GxykmwQNYXxHFdrd/7g9jDnJLBdol7zn69rn8Wt3QO0ccPqchOEfB
    bmb8ua2SWkrrQaJB/NwxpA8B0147Q709N9U9Dr/8Eh+fz55Le3s3Pk0Piap7G4Rt+c2Emz
    yhPGcMnP0RkVBSK9ZvrSGy3Ezeq5oS84vRBTN6zVgmrPe65U4Tpa3cnk5mkCcbGhr0Q9ZX
    XAXHrH1ownJQTrjqz6CAOKuss8XXDwFMm20T0DptmRBw7yHCTlnIU8Fk5w86EFMX0vxCLd
    14Dnn0WSy8XKf86DBAD9gEYluedh9n/OwVl54CGbEvKV47aosy0flt9D2/WWYbnxez29iO
    rUHQaQVxi5LhggUk9I7/MYzRDT2ZhtzRQYYM7r4R/dlpRO92zUMh3TuqUN7A
X-ME-Proxy: <xmx:btDxattEQNg9Gdnf3sq2vlUn5cRqLg0dc1w90UdQylaFNp1tlFDkJg>
    <xmx:btDxauOW6B2b8bDgBPY7Yha9-9Ce1JD1xuZlITfiyIl-uK25sniCEg>
    <xmx:btDxaj2sPREbts-pvlQFBrAIcmYPHuPw6DokGrKsLFDK1M4y1q30xQ>
    <xmx:btDxaiOlznhqoo4vobvA-yKqVsmLk07xKFQYA3lKYToCPxpo5r8cVg>
    <xmx:b9DxaogNr4gJOHAK3YhMNcGYrZxsq-A7jdFWqNfo23-qn3BHxY4b15sX>
Feedback-ID: iebe147d5:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DB8EC18E006C; Mon,  9 Nov 2026 08:53:50 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
x-forwarded-message-id: 
 <03e14024-f677-428f-b30a-c995977df6f6@app.fastmail.com>
Date: Mon, 09 Nov 2026 08:51:43 -0500
From: "Sterling Windmill" <sterling@ampx.net>
To: linux-btrfs@vger.kernel.org
Cc: "David Sterba" <dsterba@suse.com>, koraynilay <koray.fra@gmail.com>
Message-Id: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
Subject: [RFC] btrfs: forcing compression per inode via the compression property?
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(Resending as plain text; the list rejected my first copy as HTML.
Sorry for the duplicate to those on Cc.)

Hi,

compress-force can only be set for the whole filesystem. I would like
to apply it to one subvolume and leave the rest of the filesystem on
plain compress. Before writing a patch, I'd like to know whether this
would be welcome and what form it should take.

My filesystem (kernel 7.3.3, 10-device RAID10) holds both raw disk
image backups and large, already-compressed video files, and these
want opposite settings.

The images need compress-force. I copied one image (about 60G of data
in a sparse 249G file) three times with
"cp --reflink=never --sparse=always". Sizes are from compsize:

  mode                      extents   on disk   stored raw  zstd in->out
  compress-force=zstd:3     615,577     23G        11G      48G -> 12G
  compress=zstd:3 + prop    492,796     31G        27G      33G -> 4.6G
  compress=zstd:3           218,911     60G        60G     944K -> 296K

"prop" is btrfs.compression=zstd. The last copy ended up with
NOCOMPRESS set. This is one image and one sequential write, so I would
not read much into the exact percentages, but the property costs about
35% more space here than compress-force. I have not measured how much
of that comes from the heuristic's sampling and how much from data
that is compressible despite its byte distribution.

The video pays for compress-force. An 82G file had 169,776 extents and
read sequentially at 270 MB/s. After "btrfs filesystem defragment
--nocomp" it had 666 extents and read at 622 MB/s. That works, but it
has to be repeated for new files and it breaks reflinks.

As I read inode_need_compress(), FORCE_COMPRESS is only ever taken from
the mount option, and a property always goes through
btrfs_compress_heuristic(). compress_file_range() already avoids
setting NOCOMPRESS when prop_compress is set, so a per-inode force
seems to need little more than this (hypothetical field, untested):

	if (btrfs_test_opt(fs_info, FORCE_COMPRESS) ||
	    inode->prop_compress_force)
		return 1;

With that, I could mount with compress=zstd:3 and set force on the
backup subvolume, relying on the usual property inheritance.

Questions:

1. Is a per-inode force something you would accept, or would you
   rather see the heuristic improved for this kind of data?

2. What should the interface be? The per-inode compression levels
   series [1] adds "algo:level" to the same property. Would a suffix
   such as "zstd:3:force" be acceptable, or a separate property? How
   much does the behaviour of older kernels reading the value
   constrain this?

3. How should it interact with NOCOMPRESS? I assume setting force
   would clear the flag and take precedence over it. The 2020 thread
   on compress-force and per-inode settings seems to have left the
   three-state question open:
   https://lore.kernel.org/all/b92d0141-f68f-ce96-8099-e145ebc6f594@toxicpanda.com/T/

4. Should this wait until the levels series is settled?

If there is interest, I am happy to write the patch and test it on
this data.

Thanks,
Sterling Windmill

[1] https://lwn.net/Articles/1096934/
