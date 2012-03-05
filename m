From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Mon, 05 Mar 2012 18:21:02 +0800
Message-ID: <4F54938E.6080704@oracle.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>	<1330484376-16178-2-git-send-email-anand.jain@oracle.com> <CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com> <4F54625E.6040003@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F54625E.6040003@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>



>> Prior to making a new snapshot, grab the (stored) transid of the
>> previous snapshot, and check if any files have been modified in the
>> source since that transid: btrfs sub find "${source}"
>> "${previous_transid}". If nothing is returned, then you don't have to
>> bother making the snapshot at all, otherwise after making the
>> snapshot, grab the transid via btrfs sub find "${new_snapshot}" -1,
>> and store it some place (even a dot file in the root of the snapshot
>> would work).


  there might be small window of time where transid and snapshot could
  be out of sync as we know them. since there is no atomic command which
  provides both - snapshot and transid. As in the example below.
  
  Assume tgw is the transaction group write which happens after we have
  read the transaction group id.
  ---
  sync; read current tran-id and compare
  (new tgw occurs)
  snapshot
  new tgw  occurs
  sync; read current tran-id again and store
  ---

  which will result in failing to take snapshot even if there are changes.

  Certainly there will be some trade off, and below logic seems to be
  more safer...
  ---
  sync; read current tran-id and compare with previous
  new tgw occurs
  snapshot
  new tgw occurs
  store tran_id+2 (since tran_id gets added by two for a snapshot)
  ---

  which might have a situation where we have two identical snapshot.
  but a safer trade off.

thanks, Anand
  
