Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794603746;
	b=FOcKqTb7G5J7shR+z9LmQeD0wrweOOuK2kQWUny0rCXEbhjl+RtNiBJMt4L4ILOKOrb5
	 NUUNdkFaASQ/iRHtFVVNupkHz/0VyKSFr/IDAmydgNF9K55faD5dXzNx+HZxx4G8B7qKr
	 15rcfwO+oLzBD4vRZc/EatdY/FNrJs9vZA7UPkNOBL0KJNv0CqN9ZcQSoEjJvgDOgnAH/
	 fDg8TZaZYM2wSDrnDx4idMb59vsziZ0R9o9fV15LKBkBuTjhEBVEWenzLO4+nXaZvPZY8
	 zuOLDeH2wv1GuzymS0+ca3HtRyg+TldVSzP8GUkva0rkDiRvgMPxdFZcxtpkjXakTYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794603746;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=YEn6Ndu6z/kAMIMFGG+9tf6ujJHAhCtOBmNyhdoVUTM=;
	b=n/I+Ppy207C61ZK1kyTDItVmH1p0FHEtHBeB5k1p9pLFs/5ITq2uJN5k66j9Lco3mCU1
	 qJqVNaU9R/oLYHqiiXHBOFem2M6q8FJqU5+HH+HlUEhf6893xVeR3wqw+ozk4Sehmc8nQ
	 O9ObASQVu6fIIYHbRKypNKXZSgtsNHf70jzEO6j1F3srQCxV44Xc0Cic0osvKyUJKQnl2
	 YXIwDQUnWcN6VvnSho9ot+HoukEmV+98uPzOFg19TGNnEXHxPppHckN72aJ6beKv8QPjJ
	 rMrvThS6xNSvfAi13Ny3hPwcpCjQImp0M4xjsP85pq81E6pQTlgWQSfQKvpKNWTbwvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=CwxyLdkl;
	arc=none smtp.remote-ip=212.227.15.18
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5532606A336
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5532606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=CwxyLdkl
DKIM2-Signature:  i=1; m=1; t=1794603743;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:EwmyQMe4HsRyxelV3F5U1f3W91U6
   zLzJnlNFAOu6kf2rQPwEJpxRxhPuVf2XbDKS9FmWTqNGIva/nC7cm8qb5heADCQbO2kB8pXn7CG
   a6y3dmROyFpOrSz4XPqyYN3cuQS7uAfbfJjpCodhXoEU1NJiItwJd8KlhJuOzOGOmmd40bCEBLo
   QxJqhlgd2shsddc48agBnHYccZjUvHVowUIIaGWAvZtYgGB9wMbrOm3ClWLqimUUi73KYIZTMbd
   mYPjUI/UIDF6L9TNbuU4juZAg5sxAwUNTswIZ4fgzi9VB1cJczqlH4FOWVw9eGoOdbzs2t9pl5l
   6bOqvDYGO1XWmA==;
Message-Instance:  m=1;
 h=sha256:
   X4IZqeTWz4eq7OFs0z7CmDv40725Iipz0j1fGDZ4cUQ=:
   EgZ3las+6Z/oAzdXwkcPu4o/xVkVNPmHhcXQu+IshLw=,
  sha512:
   U5sdENix91ZwRerITpLo3xxdk2RjO4yJAC4JtrkJj0j7z7RXe4oZehEee3KuoXrrwMfw1qa2QDAcijbDISUc7w==:
   +bMTsFz65xqwicsoobDnSVsSq76dn6CSbOfB9mtKcn32H93dTPbu6MV2P9PcEdZNAtIvnhHsiLfpE8WsyjqUQw==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794603739; x=1795208539; i=quwenruo.btrfs@gmx.com;
	bh=YEn6Ndu6z/kAMIMFGG+9tf6ujJHAhCtOBmNyhdoVUTM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=CwxyLdklwXgV75TgeSI1ZtuEeCMlA/AHI6tMg4XO82q8RnvQfDxoceKzmeT84B/R
	 JwvrDmFpRoN/N3XnLKnE6aRxuG2aB8JQ0r359NA2I3gkkZ+rp2bCOIWdvvkK8odOo
	 5Ck2u0dgrfRUHEhxmq1vmDmjApIUA/CWp7nTISHidxKMdFdcf8MMGMpWeFRjAKR0d
	 Zctaj1bKTD1d8JIpDDipD6UAnZr71s+hVpumXEx5N7/Ze+x5Cgytfa+qMuzqiIYOE
	 dd6A0Q5tU5Tok1s8lyLu+XBnMW+H+fO2+ji+S78b5pnqnZasANiCp/dvEIHLIQpvC
	 I8F0/inWN/rXSOd9ew==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MA7Ka-1xKmLh1PWE-00EsOo; Fri, 13
 Nov 2026 22:02:19 +0100
Message-ID: <0d19eb50-751f-4297-a595-1db41b1c3938@gmx.com>
Date: Sat, 14 Nov 2026 07:32:16 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: abort transaction if btrfs_commit_transaction()
 failed
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <521fda24cf9375242f53a4842475957d8231214b.1794521916.git.wqu@suse.com>
 <CAL3q7H4qc6B7sPqCTO9iacc-xEKsciEyDO+05RaNwLf7M6vjHA@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <CAL3q7H4qc6B7sPqCTO9iacc-xEKsciEyDO+05RaNwLf7M6vjHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8SHamtktRsnDrTHLQZFZh0UwKq7HI1jqAGJc7Ceet1m5vmimGJa
 1hbq2isjSlfqDhJU5eLKbs8uxG7GfWj1ZFl7V4RyxOSXpZSMXzAFmXqA3Lj3VnA+pRJbKmi
 lyPiOACN72BkQKMO8SlU0+2heq+RLAp5ryZWCXeGK6vwqZnM6R8ESWEAO9SSDWLKHxWWI/m
 8hRofY+K1JnP5B8Y5PvXg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bSisMkLXnZ4=;fEyKk5AOxjXqdu+9mXfD7KO4w8p
 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
 +giF2H3LA37UlIb2NJMKh+8hW1A==



=E5=9C=A8 2026/11/13 21:53, Filipe Manana =E5=86=99=E9=81=93:
> On Thu, Nov 12, 2026 at 10:38=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>>
>> All other error paths of btrfs_start_dirty_block_groups() abort the
>> transaction, but the btrfs_alloc_path() failure doesn't.
>>
>> This exposed a very tiny opening that btrfs_commit_transaction() can
>> return an error without aborting transaction, and none of the callers
>> expects to handle such situation.
>>
>> Fix the only exception in btrfs_start_dirty_block_groups() path
>> allocation failure, so that btrfs_commit_transaction() always abort the
>> transaction on error.
>=20
> So there's a reason why we don't have an abort there.
> It's because it's not critical. We try to start flushing all dirty
> block groups before entering the critical section of a transaction
> commit, to avoid blocking other tasks for long periods if we have many
> dirty block groups.
>=20
> However if we fail there, and have not caused any inconsistency in the
> fs (like the failure to allocate the path), we can either try again
> the commit later or continue the transaction and then update all dirty
> block groups with btrfs_write_dirty_block_groups() inside the critical
> section.
>=20
> Currently, if a task tries to commit a transaction and fails there, it
> returns the error to user space. However, if later the transaction
> kthread tries to commit and successfully allocates the path,
> everything proceeds correctly.

I'd say failing a transaction commit, meanwhile the caller explicit want=
=20
a commmit, is a pretty bad idea.

We don't commit a transaction randomly, a lot of call sites wants every=20
to reach disks. E.g. a sync call. Then a later power loss happened,=20
meaning the sync will make no difference if it returned without abort=20
nor fully committed.

>=20
> Instead of adding the abort, I propose changing
> btrfs_commit_transaction() to continue if
> btrfs_start_dirty_block_groups() returns an error and the transaction
> was not aborted.

That sounds more reasonable.

I'd go that path in the next update.

Thanks,
Qu

>=20
> Thanks.
>=20
>=20
>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/block-group.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
>> index 027830a53f7d..e4859f7e0323 100644
>> --- a/fs/btrfs/block-group.c
>> +++ b/fs/btrfs/block-group.c
>> @@ -3397,6 +3397,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_t=
rans_handle *trans)
>>                  path =3D btrfs_alloc_path();
>>                  if (!path) {
>>                          ret =3D -ENOMEM;
>> +                       btrfs_abort_transaction(trans, ret);
>>                          goto out;
>>                  }
>>          }
>> --
>> 2.56.0
>>
>>
>=20

